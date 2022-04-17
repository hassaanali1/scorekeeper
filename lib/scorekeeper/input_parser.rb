# frozen_string_literal: true

require_relative "game"

module Scorekeeper
  # Takes a line of input and turns it into a Game or returns nil if invalid data
  class InputParser
    def self.parse_game_from_line(line)
      return nil unless validate_line(line)

      create_game_from_line(line)
    end

    def self.validate_line(line)
      /^([a-zA-Z\d]\s*)+ \d+, ([a-zA-Z\d]\s*)+ \d+$/.match?(line)
    end

    def self.create_game_from_line(line)
      t1_string_array, t2_string_array = line.split(",").map do |string|
        string.strip.split(" ")
      end
      Game.new(
        team1: t1_string_array[0...-1].join(" "),
        team2: t2_string_array[0...-1].join(" "),
        team1_goals: t1_string_array[-1].to_i,
        team2_goals: t2_string_array[-1].to_i
      )
    end
  end
end
