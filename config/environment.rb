# Load the rails application
require File.expand_path('../application', __FILE__)

RESULT = { :none => 0, :right => 1, :wrong => -1 }
RESULT_HUMAN = { 1 => "right", -1 => "wrong" }

# Initialize the rails application
EmojiCharades::Application.initialize!
