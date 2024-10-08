class CreateWorkflowsStages < ActiveRecord::Migration[7.2]
  def change
    create_table :workflows_stages do |t|
      t.belongs_to :template, foreign_key: { to_table: "workflows_templates"}
      t.string :name, default: "", null: false
      t.integer :status, default: 0, null: false
      t.integer :position, default: 1, null: false
      t.integer :default_deadline, default: 1, null: false
      t.integer :completion_type, default: 0, null: false
      t.integer :stage_type, default: 1, null: false
      t.string :colour, default: "#aaaaaa", null: false
      t.belongs_to :form_template, polymorphic: true
      t.timestamps
    end
  end
end
