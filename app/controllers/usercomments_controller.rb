class UsercommentsController < ApplicationController
  before_action :require_user_logged_in

  def create
    @photo = Photo.find(params[:usercomment][:photo_id])
    @usercomment = Usercomment.new(photo_id: @photo.id)
    @usercomments = @photo.usercomments.order(id: :desc)
    usercomment = current_user.usercomments.build(usercomment_params)
    if usercomment.save
     render 'usercomments/create.js.erb'
    end
  end

  def destroy
    usercomment = Usercomment.find(params[:id])
    id = usercomment[:photo_id]
    @photo = Photo.find(id)
    usercomment.destroy
    render 'usercomments/create.js.erb'
  end

  private

  def usercomment_params
  params.require(:usercomment).permit(:user_id, :photo_id, :content)
  end

end
