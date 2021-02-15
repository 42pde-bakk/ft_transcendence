class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :connect_user
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

  def index_no_self
    @users = User.all.where.not(:id => @current_user.id)
    respond_to do |format|
      format.html { redirect_to "/", notice: '^^' }
      format.json { render json: @users, status: :ok }
    end
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
    render json: User.clean(@current_user)
  end

  def update
    old_name = @current_user.name
    @current_user.name = params[:name]
    @current_user.img_path = params[:img_path]
    @already_in_use = User.find_by name: params[:name]
    if @already_in_use && old_name != params[:name]
      render json: {alert: "Username is already taken"}, status: :unprocessable_entity
    elsif @current_user.save
      respond_to do |format|
        format.html { redirect_to "/#profile", notice: 'Profile was successfully updated.' }
        format.json { render json: User.clean(@current_user), status: :ok }
      end
    else
      render json: {alert: "There was an error saving your changes"}, status: :unprocessable_entity
    end
  end

  private

  def connect_user
    User.all.each do |usr|
      if cookies[:log_token] == usr.log_token
        @current_user = usr
      end
    end
  end
end
