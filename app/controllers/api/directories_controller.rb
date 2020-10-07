module Api
  class DirectoriesController < ApiController
    def index
      resource = Directory.with_attached_files

      data = resource.arrange_serializable do |parent, children|
        to_hash(parent, children)
      end

      render(json: { data: data })
    end

    def archive
      keys = params[:keys]
      ArchiveJob.perform_now(keys) if keys.present? && keys.kind_of?(Array)

      head(:no_content)
    end

    private

    def to_hash(record, children)
      { key: record.id,
        id: record.id,
        title: record.name,
        isLeaf: false,
        children: children.concat(files(record.files)) }
    end

    def files(items)
      items.map do |item|
        { key: "file-#{item.id}",
          id: item.id,
          title: item.filename,
          url: url_for(item),
          isLeaf: true }
      end
    end
  end
end
