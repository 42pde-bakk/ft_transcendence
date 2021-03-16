class AdminController < ApplicationController
  
  def getAdmin
    User.all.each do |usr|
      if (usr.id.to_s == params[:id])
        @user = usr
      end
    end
    @user.admin = true
    @user.save
  end
  
  def removeAdmin
    User.all.each do |usr|
      if (usr.id.to_s == params[:id])
        @user = usr
      end
    end
    @user.admin = false
    @user.save
  end


  def ban
    User.all.each do |usr|
      if (params[:id] == usr.id.to_s)
        @target_ban = usr
      end
    end
    @target_ban.ban = true
    @target_ban.save
  end  

end
