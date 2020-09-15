class DiskController < ActiveStorage::DiskController
  def update
    super

    token = decode_verified_token
    if token
      service = AttachBlobService.new(token[:key])
      service.call
    end
  end
end
