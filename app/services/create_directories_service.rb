class CreateDirectoriesService
  attr_reader :record_id

  # @param[ActiveStorage::Blob] blob
  # @param[String] path
  def initialize(blob, path)
    @blob      = blob
    @path      = path
    @directory = nil
    @record_id = nil
  end

  def call
    return if @blob.nil?

    normalize_path!
    create_directories
    update_records
    attach_blob
  end

  private

  def normalize_path!
    @path =
      @path
      .split('/')
      .select { |r| r.present? }
      .tap(&:pop)
      .join('/')
  end

  def create_directories
    items = @path.split('/')
    items.each { |name| create_directory(name) }
    @directory = Directory.root if items.blank?
  end

  def create_directory(name)
    slug      = name.downcase
    resource  = @directory ? @directory.children : Directory.root.children
    @directory = resource.find_or_initialize_by(slug: slug)
    @directory.name = name

    begin
      @directory.save
    rescue ActiveRecord::RecordNotUnique
      @directory = resource.find_by_slug(slug)
    end
  end

  def update_records
    attrs = {}
    attrs[:key] = "#{@path}/#{@blob.key}" if @path.present?

    @blob.update(attrs)
  end

  def attach_blob
    return if @blob.nil? || @directory.nil?

    record = @directory.directory_files.find_or_create_by(blob_id: @blob.id)
    @record_id = record.id

    @directory.update(total_files: @directory.directory_files.count)
  end
end
