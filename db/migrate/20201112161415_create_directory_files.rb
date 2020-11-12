class CreateDirectoryFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :directory_files do |t|
      t.integer :directory_id, index: true
      t.integer :blob_id, index: true
    end
  end
end
