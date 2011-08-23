class GameController < ApplicationController
  before_filter :require_http_auth_user
  
  def index
    query = { :include => [:owner, { :winning_turn => :user } ] }
    if (@self_user.id and params[:only] == "friends") 
      whitelist = [@self_user.id]
      if (@self_user.friends)
        whitelist = whitelist.concat(@self_user.friends.split)
      end
      query[:conditions] = ["owner_id in (?)", whitelist]
    end
    query[:limit] = 25
    query[:order] = 'created_at desc'
    games = Game.all(query)
    render :json => games_as_json(games)
  end
  
  def create
    raise "not owner" unless params[:game][:owner_id] == @self_user.id
    game = Game.new(params[:game])
    game.save!
    send_notification("+1", "#{game.owner.name}: #{game.hint}", everyone_but(game.owner))
    render :json => game
  end

  def show
    game = Game.find(params[:id], :include => [:owner, { :turns => :user }])
    render :json => game_as_json(game)
  end
  
  def destroy
    game = Game.find_by_id(params[:id])
    if game
      raise "not owner" unless game.owner_id == @self_user.id
      Game.destroy(params[:id])
    end
    render :json => {}
  end
  
  private
  
  def games_as_json(games)
    games.to_json(
      :include => { :owner => { :only => User::public_attrs }, 
                    :winning_turn => { :include => { :user => { :only => User::public_attrs } } } })
  end
  
  def game_as_json(game)
    game.to_json(
      :include => { :owner => { :only => User::public_attrs }, 
                    :turns => { :include => { :user  => { :only => User::public_attrs } } } })
  end
  
end
