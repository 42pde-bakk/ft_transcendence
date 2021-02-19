def encrypt(log_token)
  return ((log_token.to_i + 420 - 69).to_s)
end
def decrypt(log_token)
  return ((log_token.to_i - 420 + 69).to_s)
end

class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @users = User.all
    @users.each do |usr|
      if (cookies[:log_token] == decrypt(usr.log_token))
        usr.current = true
      else
        usr.current = false
      end
    end
    render json: @users
  end

  def changeAccount
    User.all.each do |usr|
     if (decrypt(usr.log_token) == params[:new_logtoken])
       if (usr.tfa == false)
         puts('usr.log = ' + decrypt(usr.log_token))
         puts('paramLog = ' + params[:new_logtoken])
         cookies[:log_token] = params[:new_logtoken]
         @user = usr
       elsif (params[:bypass_tfa] == "true")
         if (params[:code_tfa] == cookies[:tfa_auth_code]) 
         cookies[:log_token] = params[:new_logtoken]
         @user = usr
         else 
          render json: {alert: "tfa dude"}, status: :unauthorized
         end
       else
          cookies[:tar_log_tok] = params[:new_logtoken]
          tfa_code = ((rand() * 1000).to_i).to_s
          cookies[:tfa_auth_code] = tfa_code
          TfaMailer.with(tar_log_tok:params[:new_logtoken], tfa_auth_code: tfa_code).new_tfa_code.deliver_later
          render json: {alert: "tfa dude"}, status: :unauthorized
        end
     end 
    end
  end

  def show
    User.all.each do |usr|
      if (cookies[:log_token] == decrypt(usr.log_token))
        @user = usr
      end
    end
    render json: User.clean(@user)
  end

  def update
    @user = User.find_by log_token: encrypt(cookies[:log_token])
    old_name = @user.name
    @user.name = params[:name]
    @user.img_path = params[:img_path]
    @user.tfa = params[:tfa]
    @user.email = params[:email]
    @already_in_use = User.find_by name: params[:name]
    if @already_in_use && old_name != params[:name]
      render json: {alert: "Username is already taken"}, status: :unprocessable_entity
    elsif @user.save
      # respond_to do |format|
      #   format.html { redirect_to "/#profile", notice: 'Profile was successfully updated.' }
      #   format.json { render json: @user, status: :ok }
      # end
      render json: User.clean(@user), status: :ok
    else
      render json: {alert: "There was an error saving your changes"}, status: :unprocessable_entity
    end
  end
end
