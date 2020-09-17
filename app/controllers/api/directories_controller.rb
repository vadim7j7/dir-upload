module Api
  class DirectoriesController < ApiController
    def index
      resource = Directory.with_attached_files

      data = resource.arrange_serializable do |parent, children|
        to_hash(parent, children)
      end

      render(json: { data: data })
    end

    private

    def to_hash(record, children)
      { key: record.id,
        title: record.name,
        isLeaf: false,
        children: children.concat(files(record.files)) }
    end

    def files(items)
      items.map do |item|
        { key: "file-#{item.id}",
          title: item.filename,
          url: url_for(item),
          isLeaf: true }
      end
    end
  end
end
