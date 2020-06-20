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
require 'rails_helper'

RSpec.describe Usercomment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
