class AddStatusToComments < ActiveRecord::Migration
  def change
    add_column :comments, :status, :integer, default: 1
  end
end
