def encrypt(log_token)
  return ((log_token.to_i + 420 - 69).to_s)
end
def decrypt(log_token)
  return ((log_token.to_i - 420 + 69).to_s)
end

class TournamentsController < ApplicationController
  def index_upcoming_tournaments
    @tournaments = Tournament.all.where.not(:started => true)
    respond_to do |format|
      format.html {redirect_to "/", notice: '^' }
      format.json {render json: @tournaments, status: :ok }
    end
  end

  def index_ongoing_tournaments
    @tournaments = Tournament.all.where.not(:started => false)
    respond_to do |format|
      format.html {redirect_to "/", notice: '^' }
      format.json {render json: @tournaments, status: :ok }
    end
  end

  def index_tournament_users
    tourn_id = cookies[:tourn_id].to_i
    if (cookies[:tourn_id].present?)
     @users = Tournament.all.find(tourn_id).users
    else
      @users = nil
    end 
     respond_to do |format|
      format.html {redirect_to "/", notice: '^' }
      format.json {render json: @users, status: :ok }
    end
  end

 def startTournament 
   @tourn = Tournament.find(params[:id].to_i)
   @tourn.started = true
   @tourn.save
 end

 def  registerUser
  @tourn = Tournament.find(params[:id].to_i)
  @tuser =  User.find_by log_token: encrypt(cookies[:log_token])
  if (@tuser.tournament_id == nil)
   @tourn.update(users: @tourn.users + [@tuser])
      render json: {alert: "yup"}, status: :ok
  else
      render json: {alert: "Nope"}, status: :unauthorized
  end 
end 
def checkAuthTournament
  @tuser =  User.find_by log_token: encrypt(cookies[:log_token])
  if (params[:id] != @tuser.tournament_id.to_s)
      render json: {alert: "Nope"}, status: :unauthorized
  else 
    cookies[:tourn_id] = params[:id]
  end 
end
 def create

    @tournament = Tournament.new
    @tournament.name = params[:name]
    @tournament.started = false
    if @tournament.save
      respond_to do |format|
        format.html { redirect_to "/#tournaments", notice: 'Tournament was successfully added.' }
        format.json { render json: {alert: "Added tournament"}, status: :ok }
      end
    else
      res_with_error("Failed to create new tournament", :unauthorized)
    end
  end

end
