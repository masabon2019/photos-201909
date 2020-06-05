# == Schema Information
#
# Table name: photos
#
#  id         :bigint           not null, primary key
#  comment    :string(255)
#  day        :string(255)
#  equipment  :string(255)
#  image      :string(255)
#  name       :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Photo < ApplicationRecord
  belongs_to :user

  validates :image, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :day, length: { maximum: 20 }
  validates :equipment, length: { maximum: 50 }
  validates :comment, length: { maximum: 255 }

  mount_uploader :image, ImageUploader


  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user

  has_many :goods, dependent: :destroy
  has_many :good_users, through: :goods, source: :user

end
