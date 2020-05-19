class ToppagesController < ApplicationController
  def index
    if logged_in?
      # form_with 用　インスタンス
      @photo = current_user.photos.build

      #photos　ログインユーザーの投稿写真一覧
      #@photos = current_user.photos.order(id: :desc).page(params[:page])
      @photos = Photo.all.order(id: :desc).page(params[:page])
    else
      @photos = Photo.all.order(id: :desc).page(params[:page])
    end
  end
end
