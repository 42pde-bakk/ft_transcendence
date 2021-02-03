class ProfileController < ApplicationController
  def index
    @user = User.find(1)
    render json: @user
  end
end
