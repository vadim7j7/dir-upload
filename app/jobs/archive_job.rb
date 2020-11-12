class ArchiveJob < ApplicationJob
  require 'zip'

  # :EXAMPLE:
  # [158, 'file-235', 'file-242', 'file-236', 'file-238', 161]
  #
  # @param[Array] keys
  def perform(keys = [])
    send_notification(:start)

    fill_buf(keys)

    temp_file = Tempfile.new('archive.zip')
    Zip::OutputStream.open(temp_file) do |zip|
      add_by_directories(zip)
      add_by_files(zip)
    end

    url = save_result(temp_file)
    temp_file.close

    # Send the URL to download the archive
    send_notification(:finish, 100, { url: url })
  end

  private

  # @param[Array] keys
  def fill_buf(keys)
    @added = []
    @files_ids = []
    @directories_ids = []

    keys.each do |key|
      if key.kind_of?(String)
        @files_ids << key.sub('file-', '').to_i
      elsif key.kind_of?(Integer)
        @directories_ids << key
      end
    end
  end

  # @param[Zip::OutputStream] zip
  def add_by_directories(zip)
    Directory.where(id: @directories_ids).find_each do |directory|
      directory.files.each do |blob|
        next if @added.include?(blob.id)

        add_to_archive(zip, blob, directory.path_to_str)
      end
    end
  end

  # @param[Zip::OutputStream] zip
  def add_by_files(zip)
    DirectoryFile.where(blob_id: @files_ids).find_each do |record|
      next if @added.include?(record.blob_id)

      add_to_archive(zip, file.blob, record.directory.path_to_str)
    end
  end

  # Download and add the file into the Archive
  # @param[Zip::OutputStream] zip
  # @param[ActiveStorage::Blob] blob
  # @param[String NilClass] path
  def add_to_archive(zip, blob, path)
    full_path_name = [path, blob.filename.to_s].compact.join('/')

    blob.download do |chunk|
      zip.put_next_entry(full_path_name)
      zip << chunk
    end

    @added << blob.id
  end

  # @param[Tempfile] tempfile
  def save_result(tempfile)
    # TODO need to add cleaning these files in next day.
    blob = ActiveStorage::Blob.build_after_upload(
      io: tempfile,
      filename: 'archive.zip',
      content_type: 'application/zip',
    )
    blob.save

    Rails.application.routes.url_helpers.rails_blob_path(
      blob, host: 'http://localhost:3000',
    )
  end

  def send_notification(status, percent = 0, meta = {})
    ActionCable.server.broadcast(
      'archiving_process',
      { status: status, percent: percent, meta: meta }
    )
  end
end
