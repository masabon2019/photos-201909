require 'rails_helper'

RSpec.feature "Photos", type: :feature do
  let(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678',
           password_confirmation: '12345678',
           prof_image: Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/fixtures/test.jpg'))
         )
  end

  it '新規投稿、編集、削除をする', :js => true do

    visit root_path
    click_link "login"

    expect(current_path).to eq login_path
    expect(page).to have_content "ログイン"

    ## ログインする
    fill_in "e-mail", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"

    expect(current_path).to eq "/users/#{user.id}"
    expect(page).to have_content "ログインに成功しました。"

    click_link "写真を投稿"
    attach_file "photo[image]", "spec/fixtures/test.jpg"
    fill_in "タイトル", with: "テスト写真投稿"
    fill_in "撮影日", with: "0020200103"
    fill_in "機材", with: "機材名"
    fill_in "コメント", with: "テストコメント"
    click_button "投稿する"

    expect(page).to have_content "写真を投稿しました。"

    ## 投稿を編集する
    photo = user.photos.last
    click_link nil, href: "/photos/#{photo.id}"
    expect(current_path).to eq "/photos/#{photo.id}"
    click_link '修正'
    expect(current_path).to eq edit_photo_path(photo)
    # expect(page).to have_content '投稿を編集'
    # =>実装する

    fill_in "タイトル", with: "夏の夜市"
    click_button '更新する'
    expect(current_path).to eq "/photos/#{photo.id}"
    expect(page).to have_content '夏の夜市'

    ## 投稿を削除する

    click_link "ようこそ#{user.name}さん"
    expect(current_path).to eq "/users/#{user.id}"
    puts current_path

    delete_link = find_link '削除'
    page.accept_confirm '削除してもいいですか?' do
      delete_link.click
    end

    expect(page).to have_content "写真を削除しました。"
    expect(Photo.where(id: photo.id)).to be_empty
  end
end
