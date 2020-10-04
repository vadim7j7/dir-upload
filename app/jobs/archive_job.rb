class ArchiveJob < ApplicationJob
  require 'zip'

  """
  :EXAMPLE:
  [
    241,
    236,
    {
      dir: 154,
      items: []
    },
    {
      dir: 156,
      items: [
        240,
        {
          dir: 158,
          items: [235, 242]
        }
      ]
    }
  ]
  """
  # @param[Array] data
  def perform(data = [])
    send_notification(:start)

    temp_file = Tempfile.new('archive.zip')
    Zip::OutputStream.open(temp_file) do |zip|
      build_source_map(zip, data)
    end
    url = save_result(temp_file)
    temp_file.close

    # Send the URL to download the archive
    send_notification(:finish, 100, { url: url })
  end

  private

  # @param[Zip::OutputStream] zip
  # @param[Array] data
  # @param[String, NilClass] prev_dir
  def build_source_map(zip, data, prev_dir = nil)
    data.each do |record|
      if record.kind_of?(Hash)
        directory = Directory.find_by_id(record[:dir])
        path = [prev_dir, directory.name].compact.join('/')
        if record[:items].blank? # Add to the archive all directories and files from the directory.
          build_all_sub(zip, directory, path)
        else
          build_source_map(zip, record[:items], path)
        end
      else
        attach = ActiveStorage::Attachment.find_by_id(record)
        blob = attach.blob
        add_to_archive(zip, blob, prev_dir)
      end
    end
  end

  # @param[Zip::OutputStream] zip
  # @param[Directory] directory
  # @param[String NilClass] path
  def build_all_sub(zip, directory, path) # Digging all directories and files to add into the Archive
    directory.children.each do |sub_directory|
      path = [path, sub_directory.name].compact.join('/')
      sub_directory.files.each do |file|
        add_to_archive(zip, file.blob, path)
      end

      build_all_sub(zip, sub_directory,  path)
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
