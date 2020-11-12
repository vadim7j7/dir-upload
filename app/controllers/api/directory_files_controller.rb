module Api
  class DirectoryFilesController < ApiController
    before_action :load_record!

    def completed
      @record.completed!

      head(:no_content)
    end

    private

    def load_record!
      @record = DirectoryFile.find_by_id!(params[:id])
    end
  end
end
