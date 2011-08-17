class GameController < ApplicationController
  
  def index
    games = Game.all(:include => [:owner, { :winning_turn => :user } ])
    render :json => games.to_json(
      :include => { :owner => { :only => User::public_attrs }, 
                    :winning_turn => { :include => { :user => { :only => User::public_attrs } } } })
  end

  def create
    game = Game.new(params[:game])
    game.save!
    send_notification("+1", "#{game.owner.name}: #{game.hint}", everyone_but(game.owner))
    render :json => game
  end

  def show
    game = Game.find(params[:id], :include => [:owner, { :turns => :user }])
    render :json => game.to_json(
      :include => { :owner => { :only => User::public_attrs }, 
                    :turns => { :include => { :user  => { :only => User::public_attrs } } } })
  end
  
  def destroy
    Game.destroy(params[:id])
    render :json => {}
  end
end
