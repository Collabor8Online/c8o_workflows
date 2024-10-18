class CreateWorkflowsTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :workflows_tasks do |t|
      t.belongs_to :template, foreign_key: {to_table: "workflows_templates"}
      t.belongs_to :container, polymorphic: true, index: true
      t.string :name, default: "", null: false
      t.datetime :due_on, null: false
      t.integer :position, default: 1, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
