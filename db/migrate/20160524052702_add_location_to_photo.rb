class AddLocationToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :location, :integer
  end
end
