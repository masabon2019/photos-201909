# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  email             :string(255)
#  equipment         :string(255)
#  facebook          :string(255)
#  genre             :string(255)
#  name              :string(255)
#  password_digest   :string(255)
#  prof_image        :string(255)
#  self_introduction :string(255)
#  twitter           :string(255)
#  url               :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class User < ApplicationRecord
  before_save { self.email.downcase! }

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 80 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :prof_image, presence: true
  validates :url, allow_blank: true, length: { maximum: 255 },
                  format: /\A#{URI::regexp(%w(http https))}\z/,
                  on: :update
  validates :equipment, length: { maximum: 50 }
  validates :genre, length: { maximum: 50 }
  validates :self_introduction, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :password, presence: true, length: { minimum: 8 }, on: :update,  allow_blank: true

  has_secure_password

  mount_uploader :prof_image, ImageUploader

  has_many :photos, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverses_of_relationship, source: :user

  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_photos, through: :bookmarks, source: :photo

  has_many :goods, dependent: :destroy
  has_many :good_photos, through: :goods, source: :photo

  has_many :usercomments, dependent: :destroy
  has_many :usercomment_photos, through: :usercomments, source: :photo

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

end
