require "oauth2"
require 'json'

def get_auth_tok()

  data = {grant_type: 'authorization_code', client_id: '0ebc0ed6e00f46a108cdcec53920e8bd00de8692aae747beee80e486feb5a6d2',
          client_secret: '66cb2e531d5ed30b5a53d185883f95964de1091cf1de07ece5766d04fa7830a6', code: params[:code],
          redirect_uri: 'http://127.0.0.1:3000/home'}
  uri = URI.parse('https://api.intra.42.fr/oauth/token')
  resp = Net::HTTP.post_form(uri, data)
  return (JSON.parse(resp.body)["access_token"])
end 

def encrypt(log_token)
  return ((log_token.to_i + 420 - 69).to_s)
end
def decrypt(log_token)
  return ((log_token.to_i - 420 + 69).to_s)
end

class HomeController < ApplicationController
  @new_user_form = false
  @user = nil
  def index
    if (!cookies[:atoken].present?)
      cookies[:atoken] = get_auth_tok()
    end 
    new_token = true
    User.all.each do |usr|
      if (cookies[:log_token].present? && cookies[:log_token] == decrypt(usr.log_token))
        new_token = false
        @user = usr
      end
    end
    if (new_token == true)
      @user = User.new
      @user.token = cookies[:atoken]
      def_name_used = false
      loop do
        @user.name = "New_User_" + ((rand() * 1000000).to_i).to_s
        User.all.each do |usr|
         if (usr.name == @user.name)
           def_name_used = true
          end
        end 
         if (def_name_used == false)
           break
         end 
      end
      @user.email = "ft.transcendence@gmail.com"
      @user.img_path = "https://img2.cgtrader.com/items/2043799/e1982ff5ee/star-wars-rogue-one-solo-stormtrooper-helmet-3d-model-stl.jpg"
      @user.reg_done = false
      @user.tfa = false
      @user.admin = false
      @user.owner = false
      @user.ban = false
      @user.tourn_score = 0
      log_token_used = false
      loop do 
        @n = ((rand() * 100000000).to_i).to_s
        User.all.each do |usr|
          if (decrypt(usr.log_token) == @n)
            log_token_used = true
          end
        end
        if (log_token_used == false)
          break
        end
      end
      @user.log_token = encrypt(@n)
      cookies[:log_token] = @n
      if @user.save()
        puts("User saved sucessfully")
      else
        puts("Error saving user")
      end
      @new_user_form = true
    end
    if (@user.reg_done == true)
      @new_user_form = false
    else
      @new_user_form = true
    end
  end

  def logout
  cookies.delete :log_token
  #  cookies[:log_token] = ""
    cookies.delete :atoken
  redirect_to "http://127.0.0.1:3000"
  end

  def auth
    redirect_to "https://api.intra.42.fr/oauth/authorize?client_id=0ebc0ed6e00f46a108cdcec53920e8bd00de8692aae747beee80e486feb5a6d2&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2Fhome&response_type=code"
  end
end
