# == Schema Information
#
# Table name: usercomments
#
#  id         :bigint           not null, primary key
#  content    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  photo_id   :bigint
#  user_id    :bigint
#
# Foreign Keys
#
#  fk_rails_...  (photo_id => photos.id)
#  fk_rails_...  (user_id => users.id)
#
class Usercomment < ApplicationRecord
  belongs_to :user
  belongs_to :photo

  validates :content, presence: true, length: { maximum: 140 }
end
