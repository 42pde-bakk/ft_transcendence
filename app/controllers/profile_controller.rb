class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @users = User.all
    @users.each do |usr|
      if (cookies[:log_token] == usr.log_token)
        usr.current = true
      else
        usr.current = false
      end
    end
    render json: @users
  end

  def changeAccount
    found = false
    User.all.each do |usr|
     if (usr.log_token == params[:new_logtoken])
     found = true
     cookies[:log_token] = params[:new_logtoken]
     @user = usr 
     end 
    end
  end

  def show
    User.all.each do |usr|
      if (cookies[:log_token] == usr.log_token)
        @user = usr
      end
    end
    render json: User.clean(@user)
  end

  def update
    @user = User.find_by log_token: cookies[:log_token]
    old_name = @user.name
    @user.name = params[:name]
    @user.img_path = params[:img_path]
    @already_in_use = User.find_by name: params[:name]
    if @already_in_use && old_name != params[:name]
      render json: {alert: "Username is already taken"}, status: :unprocessable_entity
    elsif @user.save
      respond_to do |format|
        format.html { redirect_to "/#profile", notice: 'Profile was successfully updated.' }
        format.json { render json: User.clean(@user), status: :ok }
      end
    else
      render json: {alert: "There was an error saving your changes"}, status: :unprocessable_entity
    end
  end
end
