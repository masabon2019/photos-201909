class UsersController < ApplicationController
  def index
    @users = User.order(id: :desc).page(params[:page]).per(10)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save!
     flash[:success] = 'ユーザーを登録しました。'
     redirect_to @user
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit
  end
  
  def update
  end

  def destroy
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :prof_image, :password, :password_digest)
    end
end
