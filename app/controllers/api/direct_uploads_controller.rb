module Api
  class DirectUploadsController < ActiveStorage::DirectUploadsController
    def create
      blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args)

      service = CreateDirectoriesService.new(blob, params[:path].to_s)
      service.call

      data = direct_upload_json(blob)
      data[:record] = service.record_id

      render(json: data)
    end
  end
end
