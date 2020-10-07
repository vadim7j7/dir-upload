class Directory < ApplicationRecord
  has_ancestry(cache_depth: true)

  has_many_attached :files

  validates :name, :slug, presence: true

  scope :root, -> { roots.where(slug: 'root').first }

  def path_to_str
    resource = path.from_depth(1)

    buf = resource.map { |dir| dir.slug }

    "#{buf.join('/')}"
  end
end
