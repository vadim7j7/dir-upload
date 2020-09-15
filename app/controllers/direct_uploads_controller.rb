class DirectUploadsController < ActiveStorage::DirectUploadsController
  def create
    blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args)

    service = CreateDirectoriesService.new(blob, params[:path].to_s)
    service.call

    render(json: direct_upload_json(blob))
  end
end
