class CreateWorkflowsTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :workflows_templates do |t|
      t.belongs_to :category, foreign_key: {to_table: "workflows_categories"}
      t.string :name, default: "", null: false
      t.belongs_to :default_owner, polymorphic: true, index: true
      t.integer :default_deadline, default: 1, null: false
      t.integer :position, default: 1, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
