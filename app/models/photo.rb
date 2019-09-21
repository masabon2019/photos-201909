class Photo < ApplicationRecord
  belongs_to :user
  
  validates :image, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :day, length: { maximum: 20 }
  validates :equipment, length: { maximum: 50 }
  validates :comment, length: { maximum: 255 }

  mount_uploader :image, ImageUploader
  
  
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user
  
  has_many :goods, dependent: :destroy
  has_many :good_users, through: :goods, source: :user

end