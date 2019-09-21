class PhotosController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :new, :show, :edit]
  before_action :correct_photo_user, only: [:edit]

  def index
  end

  def new
    @photo = Photo.new
  end
  
  def create
    @photo = current_user.photos.build(photos_params)

    if @photo.save
      flash[:success] = '写真を投稿しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '写真の投稿に失敗しました。'
      render :new
    end
      
  end

  def edit
    @photo = Photo.find(params[:id])
    @user = User.find(@photo[:user_id])
  end

  def show
    @photo = Photo.find(params[:id])
    @user = User.find(@photo[:user_id])
  end

  def destroy
    Photo.find(params[:id]).destroy
    flash[:success] = '写真を削除しました。'
    redirect_back(fallback_location: root_path)
  end

  def update
    @photo = Photo.find(params[:id])
    
    if @photo.update(photos_params)
      flash[:success] = '写真情報は正常に更新されました'
      redirect_to @photo
    else
      flash.now[:danger] = '写真情報は更新されませんでした'
      render :edit
    end
  end
  
  def photos_params
    params.require(:photo).permit(:image, :title, :day, :equipment, :comment)
  end
  
  def correct_photo_user
    @photo = Photo.find(params[:id])
    @user = User.find(@photo[:user_id])
    
    unless current_user == @user
      redirect_to root_url
    end
  end
  
end
