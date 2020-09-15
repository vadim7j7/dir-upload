class CreateDirectories < ActiveRecord::Migration[6.0]
  def change
    create_table :directories do |t|
      t.string :name
      t.string :slug, index: true

      t.string :ancestry, index: true
      t.integer :ancestry_depth, default: 0
    end

    add_index(:directories, [:slug, :ancestry], unique: true)
  end
end
