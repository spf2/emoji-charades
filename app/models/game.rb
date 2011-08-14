class Game < ActiveRecord::Base  
  include Extensions
  belongs_to :owner, :class_name => 'User'
  has_many :turns
  belongs_to :winning_turn, :class_name => 'Turn'
  validates_presence_of :owner_id
  validates_length_of(:hint,
                      :within => 1..255,
                      :too_short => "cannot be missing",
                      :too_long => "at most 255 characters")
  before_destroy :check_destroyable
  validates_numericality_of :num_turns, :winning_turn_id, :allow_nil => true
  
  def check_destroyable
    raise "cannot delete a game with turns" if turns.any?
  end
end
