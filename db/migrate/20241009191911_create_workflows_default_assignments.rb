class CreateWorkflowsDefaultAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :workflows_default_assignments do |t|
      t.belongs_to :stage, foreign_key: {to_table: "workflows_stages"}
      t.belongs_to :user, polymorphic: true, index: true
      t.timestamps
    end
  end
end
