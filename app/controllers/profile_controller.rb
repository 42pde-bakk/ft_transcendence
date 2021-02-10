class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @users = User.all
    @users.each do |usr|
      if (cookies[:atoken] == usr.token)
        usr.current = true
      else
        usr.current = false
      end
    end
    render json: @users
  end

  def show
    User.all.each do |usr|
      if (cookies[:atoken] == usr.token)
        @user = usr
      end
    end
    render json: User.clean(@user)
  end

  def update
    @user = User.find_by token: cookies[:atoken]
    @user.name = params[:name]
    @user.img_path = params[:img_path]
    @already_in_use = User.find_by name: params[:name]
    if @already_in_use
      render json: {alert: "Username is already taken"}, status: :unprocessable_entity
    elsif @user.save
      if @user.image.attached?
        print("ATTACHED")
      else
        print("NOT ATTACHED")
      end
      render json: User.clean(@user), status: :ok
    else
      render json: {alert: "There was an error saving your changes"}, status: :unprocessable_entity
    end
  end
end
