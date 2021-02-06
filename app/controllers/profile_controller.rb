class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    User.all.each do |usr|
      if (cookies[:atoken] == usr.token)
        @user = usr
      end
    end
    render json: @user
  end

  def update
    @user = User.find(params[:id])
    @user.name = params[:name]
    @user.img_path = params[:img_path]
    if @user.save
      if @user.image.attached?
        print("ATTACHED")
      else 
        print("NOT ATTACHED")
      end
      respond_to do |format|
        format.html { redirect_to "/#profile", notice: 'Profile was successfully updated.' }
        format.json { render json: @user, status: :ok }
      end
    else
      error_update
    end
  end

  private
def user_params
  params.require(:users).permit(:name, :img_path, :image)
end
  def error_update
    respond_to do |format|
      format.html { redirect_to "/#profile", alert: 'Could not update profile.' }
      format.json { render json: {alert: "Could not update profile"}, status: :unprocessable_entity }
    end
  end
end
