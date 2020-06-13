require 'rails_helper'

RSpec.describe ToppagesController, type: :controller do
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

  end
end
