class BookmarksController < ApplicationController
  before_action :require_user_logged_in

  def create
    @photo = Photo.find(params[:photo_id])
    current_user.bookmark(@photo)
    #flash[:success] = 'お気に入りに登録しました。'
    #redirect_back(fallback_location: @current_user)
    render 'create.js.erb'
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    current_user.unbookmark(@photo)
    #flash[:success] = 'お気に入りを解除しました。'
    #redirect_back(fallback_location: @current_user)
    render 'create.js.erb'
  end
end
