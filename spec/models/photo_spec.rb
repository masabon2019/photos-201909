require 'rails_helper'

RSpec.describe Photo, type: :model do

  it '有効なファクトリを持つこと' do
    expect(build(:photo)).to be_valid
  end

  it 'タイトル、イメージがある場合、有効であること' do
    user = FactoryBot.create(:user)
    photo = Photo.new(
      title: "ある初夏の海岸線にて",
      image: Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/test.jpg')),
      user: user
    )
    expect(photo).to be_valid
  end

  before do
    @photo = FactoryBot.build(:photo)
  end

  describe '存在性の検証' do
    it 'タイトルがない場合、無効であること' do
      @photo.title = nil
      expect(@photo).to_not be_valid
    end
    it '投稿写真がない場合、無効であること' do
      @photo.image = nil
      expect(@photo).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it 'タイトルが100文字以内の場合、有効であること' do
      @photo.title = 'a' * 100
      expect(@photo).to be_valid
    end
    it 'タイトルが100文字を超える場合、無効であること' do
      @photo.title = 'a' * 101
      expect(@photo).to_not be_valid
    end
  end

  describe '関連削除' do
    before do
      @user = FactoryBot.create(:user)
      @photo = FactoryBot.create(:photo)
    end

    it '投稿写真を削除すると、いいねも削除されること' do
      @user.good(@photo)
      expect(@user.goodpress?(@photo)).to eq true
      expect { @photo.destroy }.to change { @user.good_photos.count }.by(-1)
    end

    it '投稿写真を削除すると、関連する写真のお気に入りも削除されること' do
      @user.bookmark(@photo)
      expect(@user.bookmarking?(@photo)).to eq true
      expect { @photo.destroy }.to change { @user.bookmarks.count }.by(-1)
    end
  end
end
