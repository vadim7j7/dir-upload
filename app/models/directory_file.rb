class DirectoryFile < ApplicationRecord
  belongs_to :directory
  belongs_to :blob, class_name: 'ActiveStorage::Blob'
end
