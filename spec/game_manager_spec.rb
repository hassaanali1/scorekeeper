# frozen_string_literal: true

require "scorekeeper/game"
require "scorekeeper/input_parser"

RSpec.describe Scorekeeper::GameManager do
  before(:each) do
    @game_manager = Scorekeeper::GameManager.new
  end

  describe "initialize" do
    it "works properly" do
      expect { Scorekeeper::GameManager.new }.not_to raise_error
    end
  end

  describe "#parse_game" do
    it "parses a game properly" do
      game = Scorekeeper::InputParser.parse_game_from_line("The Winners 3, The Losers 2")
      expect(@game_manager.points_by_team).to eq(Hash.new(0))
      @game_manager.parse_game(game)
      expect(@game_manager.points_by_team).to eq({ "The Losers" => 0, "The Winners" => 3 })
    end

    it "parses a tie game properly" do
      game = Scorekeeper::InputParser.parse_game_from_line("The Winners 3, The Losers 3")
      expect(@game_manager.points_by_team).to eq(Hash.new(0))
      @game_manager.parse_game(game)
      expect(@game_manager.points_by_team).to eq({ "The Winners" => 1, "The Losers" => 1 })
    end

    it "displays the scoreboard after a match day" do
      games = []
      games.push(Scorekeeper::InputParser.parse_game_from_line("The Winners 1, The Losers 0"))
      games.push(Scorekeeper::InputParser.parse_game_from_line("Best Team 1, The Other Guys 0"))
      games.push(Scorekeeper::InputParser.parse_game_from_line("The Losers 1, The Other Guys 0"))
      expect(@game_manager).to receive(:display_scoreboard).exactly(1).times
      games.each do |game|
        @game_manager.parse_game(game)
      end
      expect(@game_manager)
    end

    it "displays the scoreboard after the first 2 match days" do
      games = []
      games.push(Scorekeeper::InputParser.parse_game_from_line("The Winners 1, The Losers 0"))
      games.push(Scorekeeper::InputParser.parse_game_from_line("Best Team 1, The Other Guys 0"))
      games.push(Scorekeeper::InputParser.parse_game_from_line("The Losers 1, The Other Guys 0"))
      games.push(Scorekeeper::InputParser.parse_game_from_line("Best Team 4, The Winners 3"))
      expect(@game_manager).to receive(:display_scoreboard).exactly(2).times
      games.each do |game|
        @game_manager.parse_game(game)
      end
    end
  end

  describe "#display_scoreboard" do
    it "displays the scoreboard properly and only displays the top 3 teams" do
      games = []
      games.push(Scorekeeper::InputParser.parse_game_from_line("The Winners 1, The Losers 0"))
      games.push(Scorekeeper::InputParser.parse_game_from_line("Best Team 1, The Other Guys 0"))
      games.each do |game|
        @game_manager.parse_game(game)
      end
      expected_output = "Matchday 1\nBest Team, 3 pts\nThe Winners, 3 pts\nThe Losers, 0 pts\n\n"

      expect { @game_manager.display_scoreboard }.to output(expected_output).to_stdout
    end

    it "doesn't display anything when there are no scores" do
      expect { @game_manager.display_scoreboard }.to output("").to_stdout
    end

    it "displays the current match day" do
      games = []
      games.push(Scorekeeper::InputParser.parse_game_from_line("The Winners 1, The Losers 0"))
      games.push(Scorekeeper::InputParser.parse_game_from_line("Best Team 1, The Other Guys 0"))
      games.each do |game|
        @game_manager.parse_game(game)
      end

      expect { @game_manager.display_scoreboard }.to output(/Matchday 1/).to_stdout
    end
  end
end
