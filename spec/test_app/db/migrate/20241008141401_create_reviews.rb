class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.timestamps
    end

    create_join_table :reviews, :documents
  end
end
