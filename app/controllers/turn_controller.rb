class TurnController < ApplicationController
  before_filter :require_http_auth_user

  def index
    turns = Turn.find_by_game_id(params[:game_id])
    render :json => turns
  end

  def show
    turn = Turn.find(params[:id])
    render :json => turn
  end
  
  def create
    raise "not turn user" unless params[:turn][:user_id] == @self_user.id
    turn = Turn.new(params[:turn])
    turn.save!
    send_notification("+1", "#{turn.user.name} -> #{turn.game.owner.name}: #{turn.guess}",
                      everyone_but(turn.user))
    render :json => turn
  end

  def update
    turn = Turn.find(params[:id])
    raise "not turn user" unless turn.game.owner_id == @self_user.id
    turn.result = params[:turn][:result].to_i
    send_notification("+1", "#{turn.game.owner.name} -> #{turn.user.name}: #{RESULT_HUMAN[turn.result]}",
                      everyone_but(turn.user))
    turn.save!
    render :json => turn
  end
  
  def destroy
    turn = Turn.find_by_id(params[:id])
    if (turn)
      raise "not turn user" unless turn.user_id == @self_user.id
      Turn.destroy(params[:id])
    end
    render :json => {}
  end
end
