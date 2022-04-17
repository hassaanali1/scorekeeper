# frozen_string_literal: true

require_relative "input_parser"

module Scorekeeper
  # Keeps track of teams and points, handles parsing games one by one.
  class GameManager
    attr_accessor :points_by_team, :day, :mid_match_day

    def initialize
      @day = 1
      @points_by_team = Hash.new(0)
      @team_count = nil
      @teams_played_today = []
      # Used to deal with interrupts
      @mid_match_day = false
    end

    def parse_game(game)
      return unless game

      @day == 1 ? parse_first_day_game(game) : parse_regular_game(game)
    end

    # Display only the top three teams
    def display_scoreboard
      return if @points_by_team.empty?

      puts "Matchday #{@day}"

      # Could be optimized by maintaining a sorted list of teams by points
      sorted_points = @points_by_team.sort_by { |k, v| [-v, k] }
      sorted_points[0...3].each do |score|
        team_name = score[0]
        team_points = score[1]

        suffix = team_points == 1 ? "pt" : "pts"
        puts "#{team_name}, #{team_points} #{suffix}"
      end
      puts ""
    end

    private

    def calculate_points(game)
      if game.team1_goals == game.team2_goals
        @points_by_team[game.team1] += 1
        @points_by_team[game.team2] += 1
      elsif game.team1_goals > game.team2_goals
        @points_by_team[game.team1] += 3
        @points_by_team[game.team2] += 0
      else
        @points_by_team[game.team2] += 3
        @points_by_team[game.team1] += 0
      end
    end

    # Before match day 1 is over you need to figure out how many teams there are by going until you see a repeat.
    def parse_first_day_game(game)
      if [game.team1, game.team2].any? { |team| @teams_played_today.include?(team) }
        # Need to display the scoreboard before calculating scores
        @team_count = @teams_played_today.length
        @teams_played_today = [game.team1, game.team2]
        display_scoreboard
        @day += 1
      else
        @teams_played_today.push(game.team1, game.team2)
      end
      calculate_points(game)
      # Special scenario when there's only two teams
      if @team_count == @teams_played_today.length
        display_scoreboard
        @teams_played_today = []
        @day += 1
      end
    end

    def parse_regular_game(game)
      @mid_match_day = true
      calculate_points(game)
      [game.team1, game.team2].each do |team|
        @teams_played_today.push(team)
        next unless @team_count == @teams_played_today.length

        display_scoreboard
        @teams_played_today = []
        @day += 1
        @mid_match_day = false
      end
    end
  end
end
