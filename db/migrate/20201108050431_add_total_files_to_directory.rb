class AddTotalFilesToDirectory < ActiveRecord::Migration[6.0]
  def change
    add_column :directories, :total_files, :integer, default: 0
  end
end
