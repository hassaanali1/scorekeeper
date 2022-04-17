# frozen_string_literal: true

RSpec.describe Scorekeeper::Game do
  describe "#initialize" do
    it "creates a game properly" do
      expect do
        Scorekeeper::Game.new(
          team1: "Team One",
          team2: "Team Two",
          team1_goals: 32,
          team2_goals: 0
        )
      end.not_to raise_error
    end
  end
end
