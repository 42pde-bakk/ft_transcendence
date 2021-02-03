class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @user = User.find(1)
    render json: @user
  end

  def update
    puts "---------------------"
    puts params
    puts "!!!!!!!!!!!!!!!!!!!!!"
    @user = User.find(params[:id])
    @user.name = params[:name]
    @user.level = params[:level]
    if @user.save
      puts @user.inspect
      puts "---------------------"
      render json: @user
    else
      puts "Did not save !!!!!!!!"
    end
  end

end
