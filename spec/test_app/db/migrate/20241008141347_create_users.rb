class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, default: "", null: false
      t.string :email, default: "", null: false
      t.boolean :admin, default: false, null: false
      t.timestamps
    end
  end
end
