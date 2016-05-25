class RenameBodyToMessageInComments < ActiveRecord::Migration
  def change
    rename_column :comments, :body, :message
  end
end
