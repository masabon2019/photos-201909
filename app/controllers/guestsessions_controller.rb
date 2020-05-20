class GuestsessionsController < ApplicationController
  def create
    user = User.find_by(email: "guest@example.com")
    session[:user_id] = user.id
    flash[:success] = "ゲストユーザーとしてログインしました。"
    redirect_to user
  end
end
