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

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  it '有効なファクトリを持つこと' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it '名前、メール、パスワード、プロフイメージがある場合、有効であること' do
    user = User.new(
      name: "testuser",
      email: "testuser@example.com",
      password: "password",
      password_confirmation: "password",
      prof_image: Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/test.jpg'))
    )
    expect(user).to be_valid
  end

  describe '存在性の検証' do
    it '名前がない場合、無効であること' do
      @user.name = nil
      expect(@user).to_not be_valid
    end

    it 'メールアドレスがない場合、無効であること' do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it 'プロフイメージがない場合、無効であること' do
      @user.prof_image = nil
      expect(@user).to_not be_valid
    end

    it 'パスワードがない場合、無効であること' do
      @user.password = nil
      @user.password_confirmation = nil
      expect(@user).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it '名前が20文字以内の場合、有効であること' do
      @user.name = 'a' * 20
      expect(@user).to be_valid
    end

    it '名前が20文字を超える場合、無効であること' do
      @user.name = 'a' * 21
      expect(@user).to_not be_valid
    end

    it 'メールアドレスが80文字以内の場合、有効であること' do
      @user.email = 'a' * 68 + '@example.com'
      expect(@user).to be_valid
    end

    it 'メールアドレスが80文字を越える場合、無効であること' do
      @user.email = 'a' * 69 + '@example.com'
      expect(@user).to_not be_valid
    end

    it 'ジャンルが50文字以内の場合、有効であること' do
      @user.genre = 'a' * 50
      expect(@user).to be_valid
    end

    it 'ジャンルが50文字を越える場合、無効であること' do
      @user.genre = 'a' * 51
      expect(@user).to_not be_valid
    end

    it '機材が50文字を越える場合、無効であること' do
      @user.equipment = 'a' * 51
      expect(@user).to_not be_valid
    end

    it '自己紹介が255文字を越える場合、無効であること' do
      @user.self_introduction = 'a' * 256
      expect(@user).to_not be_valid
    end

    it 'パスワードが8文字以上の場合、有効であること' do
      @user.password = @user.password_confirmation = 'a' * 8
      expect(@user).to be_valid
    end

    it 'パスワードが8文字未満の場合、無効であること' do
      @user.password = @user.password_confirmation = 'a' * 7
      expect(@user).to_not be_valid
    end

  end

  describe '一意性の検証' do
    it '重複した名前の場合、無効であること' do
      other_user = FactoryBot.create(:user)
      @user.name = other_user.name
      expect(@user).to_not be_valid
    end

    it '重複したメールアドレスの場合、無効であること' do
      other_user = FactoryBot.create(:user)
      @user.email = other_user.email
      expect(@user).to_not be_valid
    end

    it 'メールアドレスは大文字小文字を区別せず一意性を判断する' do
      other_user = FactoryBot.create(:user, email:'alice@example.com')
      @user.email = 'AliCe@example.com'
      expect(@user).to_not be_valid
    end

    it 'メールアドレスは全て小文字で保存される' do
      mixed_case_email = "tEstUser@ExAMPle.CoM"
      @user.email = mixed_case_email
      @user.save
      assert_equal mixed_case_email.downcase, @user.reload.email
    end
  end

  describe 'パスワードの検証' do
    it 'パスワードと確認用パスワードが不一致の場合、無効であること' do
      @user.password_confirmation = @user.password+'x'
      expect(@user).to_not be_valid
    end

    it 'パスワードと確認用パスワードが一致の場合、有効であること' do
      @user.password_confirmation = @user.password
      expect(@user).to be_valid
    end
  end

  describe '関連性' do
    it 'ユーザーを削除すると、投稿写真も削除されること' do
        user = FactoryBot.create(:user, :with_photos, photos_count: 3)
        expect { user.destroy }.to change { Photo.count }.by(-3)
    end

    it 'ユーザーを削除すると、いいねも削除されること' do
      user = FactoryBot.create(:user)
      photo = FactoryBot.create(:photo)
      user.good(photo)
      expect(user.goodpress?(photo)).to eq true
      expect { user.destroy }.to change { user.good_photos.count }.by(-1)
    end

    it 'ユーザーを削除すると、写真のお気に入りも削除されること' do
      user = FactoryBot.create(:user)
      photo = FactoryBot.create(:photo)
      user.bookmark(photo)
      expect(user.bookmarking?(photo)).to eq true
      expect { user.destroy }.to change { user.bookmark_photos.count }.by(-1)
    end

    it '自分自身はフォローできない' do
      user = FactoryBot.create(:user)
      other_user = user
      user.follow(other_user)
      expect(user.following?(other_user)).to eq false
    end

    it 'ユーザーを削除すると、フォロー関係も削除されること' do
      user = FactoryBot.create(:user)
      other_user = FactoryBot.create(:user)
      user.follow(other_user)
      expect(user.following?(other_user)).to eq true
      expect { user.destroy }.to change { user.followings.count }.by(-1)
    end

    it 'ユーザーを削除すると、フォローワー関係も削除されること' do
      user = FactoryBot.create(:user)
      other_user = FactoryBot.create(:user)
      other_user.follow(user)
      expect(other_user.following?(user)).to eq true
      expect { user.destroy }.to change { other_user.followings.count }.by(-1)
    end
  end

  describe 'フォーマットの検証' do
    it 'メールアドレスが正常なフォーマットの場合、有効であること' do
      valid_addresses = %w[
        user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn
      ]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end

    it 'メールアドレスが不正なフォーマットの場合、無効であること' do
      invalid_addresses = %w[
        user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com
      ]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.valid?
        expect(@user.errors).to be_added(:email, :invalid, value: invalid_address)
      end
    end
  end

end
