class GoodsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    photo = Photo.find(params[:photo_id])
    current_user.good(photo)
    flash[:success] = '「Good」しました。'
    redirect_back(fallback_location: @current_user)
  end

  def destroy
    photo = Photo.find(params[:photo_id])
    current_user.ungood(photo)
    flash[:success] = '「Good」を解除しました。'
    redirect_back(fallback_location: @current_user)
  end
end