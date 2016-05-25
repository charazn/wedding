class User < ActiveRecord::Base
  authenticates_with_sorcery!
  acts_as_voter

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? }
  validates :password_confirmation, presence: true, if: -> { new_record? }

  has_many :photos

  has_attached_file :image, styles: { navbar: "30x30#", profile: "300x300#" } 
  validates_attachment :image, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  has_many :comments_received, as: :commentable, class_name: "Comment"
  has_many :comments_made, class_name: "Comment", foreign_key: :commenter_id

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  enum role: { admin: 0, regular: 1 }
  enum location: { hk: 0, sg: 1, sh: 2 }
end
