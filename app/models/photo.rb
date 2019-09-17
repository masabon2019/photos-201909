class Photo < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  
  validates :image, presence: true
  
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user
  
  has_many :goods, dependent: :destroy
  has_many :good_users, through: :goods, source: :user

end