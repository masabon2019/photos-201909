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
FactoryBot.define do
  factory :user do
    #name { 'Aaron Sumner' }
    sequence(:name) { |n| "tester#{n}" }
    #email { 'tester@example.com' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    prof_image { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/test.jpg')) }
    password { 'dottle-nouveau-pavilion-tights-furze' }
    password_confirmation { 'dottle-nouveau-pavilion-tights-furze' }
  end

  trait :with_photos do
    transient do
      photos_count { 5 }
    end

    after(:create) do |user, evaluator|
      create_list(:photo, evaluator.photos_count, user: user)
    end

    #after(:create) { |user| create_list(:photo, 5, user: user) }
  end

  #trait :with_goods do
  #  transient do
  #    goods_count { 5 }
  #  end

  #  after(:create) do |user, evaluator|
  #    create_list(:good, evaluator.goods_count, user: user)
  #  end
  #end

end
