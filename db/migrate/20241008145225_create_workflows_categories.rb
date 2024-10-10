class CreateWorkflowsCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :workflows_categories do |t|
      t.belongs_to :container, polymorphic: true, index: true
      t.string :name, default: "", null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
