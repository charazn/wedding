class AddLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :integer
  end
end
