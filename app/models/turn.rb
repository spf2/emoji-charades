class Turn < ActiveRecord::Base
  include Extensions
  before_create :result_not_specified
  belongs_to :game, :touch => true
  belongs_to :user
  validates_presence_of :game
  validates_presence_of :user
  validates_length_of(:guess,
                      :maximum => 255,
                      :message => "1-255 characters")
  before_destroy :check_destroyable
  after_destroy :decrement_num_turns
  after_create :increment_num_turns
  after_update :maybe_update_game

  def check_destroyable
    raise "cannot delete a turn with result" unless result == RESULT[:none]
    raise "cannot delete turn on finished game" if game.done_at
  end

  def result_not_specified
    result.nil? or RESULT[:none]
  end

  def maybe_update_game
    if game.done_at.nil? and result == RESULT[:right]
      game.winning_turn_id = id
      game.done_at = Time.now
      game.save!
    end
  end
  
  def increment_num_turns
    game.num_turns += 1
    game.save!
  end
  
  def decrement_num_turns
    game.num_turns -= 1
    game.save!
  end
end
