class AdminController < ApplicationController
  
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
