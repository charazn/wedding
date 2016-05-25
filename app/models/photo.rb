class Photo < ActiveRecord::Base
  acts_as_votable

  belongs_to :user

  has_attached_file :image, styles: { list: "300x300>", single: "900x900>" }
  validates_attachment :image, presence: true, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  enum status: { archived: 0, active: 1 }
  enum location: { hk: 0, sg: 1, sh: 2 }
  scope :recent_first, -> { order("updated_at desc") }
  scope :active, -> { where(status: 1) }
  scope :archived, -> { where(status: 0) }

  has_many :comments, as: :commentable

end
