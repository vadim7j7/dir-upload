class ArchiveJob < ApplicationJob
  # @param[Array] ids
  def perform(ids)
    temp_file = Tempfile.new('archive.zip')
    Zip::OutputStream.open(temp_file) do |zip|
      ActiveStorage::Attachment.where(id: ids).find_each do |attach|
        attach.blob.download do |chunk|
          zip.put_next_entry(attach.blob.filename.to_s)
          zip << chunk
        end
      end
    end
  end
end
