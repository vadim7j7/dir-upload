class ArchiveJob < ApplicationJob
  """
  :EXAMPLE:
  [
    241,
    236,
    {
      dir: 159,
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
    temp_file = Tempfile.new('archive.zip')
    Zip::OutputStream.open(temp_file) do |zip|
      build_source_map(zip, data)
    end

    temp_file.close
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
        build_source_map(zip, record[:items], path)
      else
        attach = ActiveStorage::Attachment.find_by_id(record)
        blob = attach.blob
        add_to_archive(zip, blob, prev_dir)
      end
    end
  end

  # @param[Zip::OutputStream] zip
  # @param[ActiveStorage::Blob]
  # @param[String NilClass] path
  def add_to_archive(zip, blob, path)
    full_path_name = [path, blob.filename.to_s].compact.join('/')

    blob.download do |chunk|
      zip.put_next_entry(full_path_name)
      zip << chunk
    end
  end
end
