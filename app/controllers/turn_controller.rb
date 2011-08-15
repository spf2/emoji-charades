class TurnController < ApplicationController

  def index
    turns = Turn.find_by_game_id(params[:game_id])
    render :json => turns
  end

  def show
    turn = Turn.find(params[:id])
    render :json => turn
  end
  
  def create
    turn = Turn.new(params[:turn])
    turn.save!
    send_notification("+1", "#{turn.game.owner.name}: #{turn.guess}", everyone_but(turn.user))
    render :json => turn
  end

  def update
    turn = Turn.find(params[:id])
    # TODO(spf): ensure that updater is game owner
    turn.result = params[:turn][:result].to_i
    send_notification("+1", "#{turn.user.name}: #{RESULT_HUMAN[turn.result]}", everyone_but(turn.user))
    turn.save!
    render :json => turn
  end
  
  def destroy
    Turn.destroy(params[:id])
    render :json => {}
  end
end
