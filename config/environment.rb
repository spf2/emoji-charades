# Load the rails application
require File.expand_path('../application', __FILE__)

RESULT = { :none => 0, :right => 1, :wrong => -1 }
RESULT_HUMAN = { :right => "right", :wrong => "wrong" }

# Initialize the rails application
EmojiCharades::Application.initialize!
