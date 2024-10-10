class CreateWorkflowsOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :workflows_options do |t|
      t.belongs_to :stage, foreign_key: {to_table: "workflows_stages"}
      t.string :name, default: "", null: false
      t.string :colour, default: "#888888", null: false
      t.belongs_to :destination_stage, foreign_key: {to_table: "workflows_stages"}
      t.timestamps
    end
  end
end
