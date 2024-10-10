class CreateFolders < ActiveRecord::Migration[7.2]
  def change
    create_table :folders do |t|
      t.belongs_to :project, foreign_key: true
      t.string :name, default: "", null: false
      t.timestamps
    end
  end
end
