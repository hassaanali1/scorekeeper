# frozen_string_literal: true

require "scorekeeper/game"

RSpec.describe Scorekeeper::InputParser, "#parse_game_from_line" do
  context "valid inputs" do
    it "returns a valid game when the input is valid" do
      input = "San Jose Earthquakes 3, Santa Cruz Slugs 3"
      expected_game_result = Scorekeeper::Game.new(
        team1: "San Jose Earthquakes",
        team2: "Santa Cruz Slugs",
        team1_goals: 3,
        team2_goals: 3
      )
      resulting_game = Scorekeeper::InputParser.parse_game_from_line(input)
      expect(compare_games(resulting_game, expected_game_result)).to eq(true)
    end

    it "returns a valid game when scores are in the double digits" do
      input = "San Jose Earthquakes 15, Santa Cruz Slugs 0"
      expected_game_result = Scorekeeper::Game.new(
        team1: "San Jose Earthquakes",
        team2: "Santa Cruz Slugs",
        team1_goals: 15,
        team2_goals: 0
      )
      resulting_game = Scorekeeper::InputParser.parse_game_from_line(input)
      expect(compare_games(resulting_game, expected_game_result)).to eq(true)
    end

    it "returns a valid game when team names are very long" do
      team1 = "The Quick Brown Foxes Who Jump Over Lazy Dogs"
      team2 = "The Same Words Over And Over The Same Words Over And Over The Same Words Over And Over"
      input = "#{team1} 3, #{team2} 3"
      expected_game_result = Scorekeeper::Game.new(
        team1: team1,
        team2: team2,
        team1_goals: 3,
        team2_goals: 3
      )
      resulting_game = Scorekeeper::InputParser.parse_game_from_line(input)
      expect(compare_games(resulting_game, expected_game_result)).to eq(true)
    end

    it "returns a valid game when team name contains numbers" do
      input = "Ottawa 67s 3, San Fransisco 49ers 10"
      expected_game_result = Scorekeeper::Game.new(
        team1: "Ottawa 67s",
        team2: "San Fransisco 49ers",
        team1_goals: 3,
        team2_goals: 10
      )
      resulting_game = Scorekeeper::InputParser.parse_game_from_line(input)
      expect(compare_games(resulting_game, expected_game_result)).to eq(true)
    end
  end

  context "invalid inputs" do
    it "returns nil when team name contains special characters" do
      input = "San J%ose Earthquakes 3, Other Guys 1"
      expect(Scorekeeper::InputParser.parse_game_from_line(input)).to be_nil
    end

    it "returns nil when team name contains apostrophes" do
      input = "Ottawa 67's 3, Other Guys 1"
      expect(Scorekeeper::InputParser.parse_game_from_line(input)).to be_nil
    end

    it "returns nil when there isn't a score" do
      input = "San Jose Earthquakes , Other Guys 1"
      expect(Scorekeeper::InputParser.parse_game_from_line(input)).to be_nil
    end

    it "returns nil when given an empty string" do
      input = ""
      expect(Scorekeeper::InputParser.parse_game_from_line(input)).to be_nil
    end

    it "returns nil when there is whitespace at the end of the input" do
      input = "San Jose Earthquakes 3, Other Guys 1   "
      expect(Scorekeeper::InputParser.parse_game_from_line(input)).to be_nil
    end

    it "returns nil when a score has a negative number" do
      input = "San Jose Earthquakes -3, Other Guys 1"
      expect(Scorekeeper::InputParser.parse_game_from_line(input)).to be_nil
    end
  end

  private

  def compare_games(game1, game2)
    game1.team1 == game2.team1 &&
      game1.team2 == game2.team2 &&
      game1.team1_goals == game2.team1_goals &&
      game1.team2_goals == game2.team2_goals
  end
end
