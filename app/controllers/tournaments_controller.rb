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

  
  def create_tournament
  end
end
