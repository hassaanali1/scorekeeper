# frozen_string_literal: true

require_relative "./scorekeeper/version"
require_relative "./scorekeeper/game_manager"

# Takes an input stream (ARGF), parses games and sends them to the GameManager
module Scorekeeper
  def self.keep_score(input_stream)
    game_manager = GameManager.new

    input_stream.each do |line|
      game = InputParser.parse_game_from_line(line)
      game_manager.parse_game(game) if game
    end

    # Required when there's only one match day or an interrupt
    game_manager.display_scoreboard if game_manager.day == 1 || game_manager.mid_match_day
  end
end
