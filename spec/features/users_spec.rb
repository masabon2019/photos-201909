require "rails_helper"

RSpec.feature "Users", type: :feature do
  scenario "ユーザーは新しい写真を投稿する" do
    user = FactoryBot.create(:user)

    visit root_path
    click_link "login"
    fill_in "e-mail", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"

    expect {
      click_link "写真を投稿"
      attach_file "photo[image]", "spec/fixtures/test.jpg"
      fill_in "タイトル", with: "テスト写真投稿"
      fill_in "撮影日", with: "2020/01/03"
      fill_in "機材", with: "機材名"
      fill_in "コメント", with: "テストコメント"
      click_button "投稿する"

      expect(page).to have_content "写真を投稿しました。"
    }.to change(user.photos, :count).by(1)

  end

  scenario "ユーザーを新規登録する" do
    visit root_path
    within("#top-btns") do
      click_link "ユーザー登録"
    end
    expect{
      fill_in "名前", with: "テストユーザー"
      fill_in "e-mail", with: "tester@example.com"
      fill_in "パスワード", with: "12345678"
      fill_in "パスワード確認", with: "12345678"
      attach_file "user[prof_image]", "spec/fixtures/test.jpg"
      click_button "登録する"

    expect(page).to have_content "ユーザーを登録しました。"
  }.to change{User.count}.by(1)
  end
  scenario ""
end
