class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :commentable, polymorphic: true, index: true
      t.integer :commenter_id, index: true

      t.timestamps null: false
    end

    add_foreign_key :comments, :users, column: :commenter_id

  end
end
