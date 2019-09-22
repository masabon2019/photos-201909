class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                  uniqueness: { case_sensitive: false }
  validates :prof_image, presence: true
  validates :equipment, length: { maximum: 50 }
  validates :genre, length: { maximum: 50 }
  validates :url, length: { maximum: 255 }, format: /\A#{URI::regexp(%w(http https))}\z/, if: :correct_url?
  validates :self_introduction, length: { maximum: 255 }
  has_secure_password
  
  mount_uploader :prof_image, ImageUploader 
  
  has_many :photos
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_photos, through: :bookmarks, source: :photo
  
  has_many :goods, dependent: :destroy
  has_many :good_photos, through: :goods, source: :photo

  def follow(other_user)
    unless self == other_user
  		self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
  	relationship = self.relationships.find_by(follow_id: other_user.id)
  	relationship.destroy if relationship
  end

  def following?(other_user)
  	self.followings.include?(other_user)
  end 
  
  def bookmark(other_photo)
    self.bookmarks.find_or_create_by(photo_id: other_photo[:id])
  end
  
  def unbookmark(other_photo)
    bookmark = self.bookmarks.find_by(photo_id: other_photo[:id])
    bookmark.destroy if bookmark
  end
  
  def bookmarking?(other_photo)
    self.bookmark_photos.include?(other_photo)
  end
  
  def good(other_photo)
    self.goods.find_or_create_by(photo_id: other_photo[:id])
  end
  
  def ungood(other_photo)
    good = self.goods.find_by(photo_id: other_photo[:id])
    good.destroy if good
  end
  
  def goodpress?(other_photo)
    self.good_photos.include?(other_photo)
  end
  
  def correct_url?
    self.url != nil
  end

end
