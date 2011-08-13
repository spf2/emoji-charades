class AddTurnDataToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :num_turns, :integer, :default => 0
    add_column :games, :winning_turn_id, :integer
    Game.all.each do |game|
      game.num_turns = game.turns.length
      game.turns.each do |turn|
        if turn.result == RESULT[:right]
          game.winning_turn_id = turn.id
        end
      end
      game.save!
    end
  end

  def self.down
    remove_column :games, :winning_turn_id
    remove_column :games, :num_turns
  end
end
