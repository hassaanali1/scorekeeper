# frozen_string_literal: true

module Scorekeeper
  # Represents a game which has 2 teams and a score.
  class Game
    attr_accessor :team1, :team2, :team1_goals, :team2_goals

    def initialize(team1:, team2:, team1_goals:, team2_goals:)
      @team1 = team1
      @team2 = team2
      @team1_goals = team1_goals
      @team2_goals = team2_goals
    end
  end
end
