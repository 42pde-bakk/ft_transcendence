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

 def startTournament 
   @tourn = Tournament.find(params[:id].to_i)
   @tourn.started = true
   @tourn.save
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
