class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit, :followings, :followers]
  before_action :correct_user, only: [:edit]

  def index
    @users = User.order(id: :desc).page(params[:page]).per(8)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
     flash[:success] = 'ユーザーを登録しました。'
     redirect_to @user
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @photos = @user.photos.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def edit
    @user = User.find(params[:id])
    if @user.id = 18
    flash.now[:danger] = 'ゲストユーザーはユーザー登録情報の変更はできません'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = 'ユーザー情報は正常に更新されました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザー情報は更新されませんでした'
      render :edit
    end
  end

  def destroy
  end

  #followingsの一覧
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  def bookmarkings
    @user = User.find(params[:id])
    @bookmarks = @user.bookmark_photos.page(params[:page])
    counts(@user)
  end

  def correct_user
    @user = User.find(params[:id])

    unless current_user == @user
      redirect_to root_url
    end
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :prof_image, :password, :password_confirmation, :equipment, :genre, :url, :self_introduction)
    end
end
