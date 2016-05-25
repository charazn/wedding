class ChangeColumnMessageFromTextToStringInUsers < ActiveRecord::Migration
  def change
    change_column :comments, :message, :string
  end

  def down
    change_column :comments, :message, :text
  end
end

# Have to specify up down. Rails only knows how to reverse the following commands:
# http://api.rubyonrails.org/classes/ActiveRecord/Migration/CommandRecorder.html
