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

FactoryBot.define do
  factory :photo do
    comment { '鴨川の河川敷で写真を撮ってみました。' }
    equipment { 'EOS' }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    title { '鴨川にて' }
    association :user
  end
end
