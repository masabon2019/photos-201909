require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  describe "#index" do
    it "正常にレスポンスを返すこと" do
      get :index
      expect(response).to_not be_success
      puts "response.status: #{response.status}"
      puts "response.message: #{response.message}"
    end
    it "200レスポンスを返すこと" do
      get :index
      expect(response).to have_http_status "200"
    end
    it "ダブルにメソッドがない" do
      dbl = double("Something")
      allow(dbl).to receive(:foo)
      expect(dbl.foo).to be_nil
    end
    it "ダブルにメソッドがある" do
      user = double("user", name: "名前", login: true)
      puts user.name
      #puts user.id
      expect(user.name).to eq "名前"
    end
  end

end
