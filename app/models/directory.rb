class Directory < ApplicationRecord
  has_ancestry(cache_depth: true)

  has_many_attached :files

  validates :name, :slug, presence: true

  scope :root, -> { roots.where(slug: 'root').first }
end
