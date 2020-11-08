class AttachBlobService
  def initialize(blob_key)
    @blob_key = blob_key
  end

  def call
    load_records
    attach_blob
  end

  private

  def load_records
    @blob      = ActiveStorage::Blob.find_by_key(@blob_key)
    @directory = Directory.find(@blob.director_id)
  end

  def attach_blob
    @directory.files.attach(@blob)
    @directory.update(total_files: @directory.files.count)
  end
end
