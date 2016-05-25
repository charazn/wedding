class AddStatusToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :status, :integer, default: 1
  end
end
