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

def index_tournament_current_game
  tourn_id = cookies[:tourn_id].to_i
    if (cookies[:tourn_id].present?)
     @tourn = Tournament.all.find(tourn_id)
     if (@tourn.games.count == 0)
       @curr_game = nil
    else
     @curr_game = [@tourn.games[0]]
    end
    else
      @tourn = nil
      @curr_game = nil
    end
   respond_to do |format|
      format.html {redirect_to "/", notice: '^' }
      format.json {render json: @curr_game, status: :ok }
    end
end

 def startTournament 
   @tourn = Tournament.find(params[:id].to_i)
   if (@tourn.users.count < 2)
      render json: {alert: "Not enough player in tournament"}, status: :unauthorized
   end
    @tourn.started = true
   #Prepare tournament match list 
   @user_list = @tourn.users
   x = 0
   while x < @user_list.count - 1
    y = x + 1
    while y < @user_list.count
      #peer has player1_name && player2_name, might need to add that after next merge ! 
      new_game = Game.create(player1_id: @user_list[x].id, player2_id: @user_list[y].id,
                          name_player1: @user_list[x].name, name_player2:@user_list[y].name,
                          gametype: "ranked", extra_speed: @tourn.extra_speed, long_paddles: @tourn.long_paddle)
      new_game.mysetup
      new_game.save
      @tourn.update(games: @tourn.games + [new_game])
      y += 1
    end 
   x += 1
   end 
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

def endTournament
  @tourn = Tournament.find(cookies[:tourn_id])
  max = 0
  max_id = 0 
  @tourn.users.each do |usr|
    if (usr.tourn_score > max)
      max = usr.tourn_score
      max_id = usr.id
    end
  end
  @tourn.users.each do |usrs|
    if (usrs.tourn_score == max)
      usrs.elo += 250
    end
  end
  @tourn.users.each do |user_x|
    user_x.tournament_id = nil
    user_x.tourn_score = 0
    user_x.save
  end
  @tourn.delete
end

 def create

    @tournament = Tournament.new
    @tournament.name = params[:name]
    @tournament.long_paddle = params[:long_paddle]
    @tournament.extra_speed = params[:extra_speed]
    @tournament.started = false
    @tournament.game_index = 0
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
