class CreateDirectoriesService
  # @param[ActiveStorage::Blob] blob
  # @param[String] path
  def initialize(blob, path)
    @blob      = blob
    @path      = path
    @directory = nil
  end

  def call
    return if @blob.nil?

    normalize_path!
    create_directories
    update_records
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
    attrs[:key] = "#{@path}/#{@blob.key}" if @path
    attrs[:director_id] = @directory.id if @directory

    @blob.update(attrs)
  end
end
