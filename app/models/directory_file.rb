class DirectoryFile < ApplicationRecord
  belongs_to :directory
  belongs_to :blob, class_name: 'ActiveStorage::Blob'

  enum status: %i[progress completed failed]
end
