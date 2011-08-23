# Load the rails application
require File.expand_path('../application', __FILE__)

RESULT = { :none => 0, :right => 1, :wrong => -1 }
RESULT_HUMAN = { 1 => [0xe00e].pack('U'), -1 => [0xe421].pack('U') }

# Initialize the rails application
EmojiCharades::Application.initialize!
