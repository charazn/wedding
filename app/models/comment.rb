class Comment < ActiveRecord::Base

  validates :message, presence: true
  validates :commenter, presence: true

  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, class_name: "User"

  enum status: { archived: 0, active: 1 }
  default_scope { order("created_at desc") }
  scope :active, -> { where(status: 1) }
  scope :archived, -> { where(status: 0) }

end
