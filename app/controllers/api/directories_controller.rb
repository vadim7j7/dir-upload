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
        slug: record.slug,
        title: record.name,
        isLeaf: false,
        files: files(record.files),
        children: children  }
    end

    def files(items)
      items.map do |item|
        { name: item.filename,
          key: "file-#{item.id}" }
      end
    end
  end
end
