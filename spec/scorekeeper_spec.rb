# frozen_string_literal: false

RSpec.describe Scorekeeper do
  it "has a version number" do
    expect(Scorekeeper::VERSION).not_to be nil
  end

  describe "#keep_score" do
    it "can handle the sample input and return proper output" do
      file_number = 1
      compare_files(
        "spec/input_files/sample_input_#{file_number}.txt",
        "spec/expected_outputs/expected_output_#{file_number}.txt"
      )
    end

    it "can handle input with only a single game" do
      file_number = 2
      compare_files(
        "spec/input_files/sample_input_#{file_number}.txt",
        "spec/expected_outputs/expected_output_#{file_number}.txt"
      )
    end

    it "can handle input where there's only two teams" do
      file_number = 3
      compare_files(
        "spec/input_files/sample_input_#{file_number}.txt",
        "spec/expected_outputs/expected_output_#{file_number}.txt"
      )
    end

    it "can handle input where a match day is interrupted half way through" do
      file_number = 4
      compare_files(
        "spec/input_files/sample_input_#{file_number}.txt",
        "spec/expected_outputs/expected_output_#{file_number}.txt"
      )
    end

    it "can handle 4 teams and only one match day" do
      # This test is to make sure teams with 0 points are displayed if theyre in the top 3
      file_number = 5
      compare_files(
        "spec/input_files/sample_input_#{file_number}.txt",
        "spec/expected_outputs/expected_output_#{file_number}.txt"
      )
    end

    it "can deal with files with invalid data" do
      file_number = 6
      io = StringIO.new
      File.readlines("spec/input_files/sample_input_#{file_number}.txt").each do |line|
        io.puts(line)
      end
      io.rewind

      expected_output = ""
      expect { Scorekeeper.keep_score(io) }.to output(expected_output).to_stdout
    end

    it "can handle files with valid and invalid data" do
      file_number = 7
      compare_files(
        "spec/input_files/sample_input_#{file_number}.txt",
        "spec/expected_outputs/expected_output_#{file_number}.txt"
      )
    end

    it "can deal with large files" do
      file_number = 8
      compare_files(
        "spec/input_files/sample_input_#{file_number}.txt",
        "spec/expected_outputs/expected_output_#{file_number}.txt"
      )
    end

    it "can deal with empty files" do
      io = StringIO.new
      io.puts("")
      io.rewind

      expected_output = ""
      expect { Scorekeeper.keep_score(io) }.to output(expected_output).to_stdout
    end

    private

    def compare_files(input_filename, output_filename)
      io = StringIO.new
      File.readlines(input_filename).each { |line| io.puts(line) }
      io.rewind

      expected_output = ""
      File.readlines(output_filename).each { |line| expected_output << line }
      expected_output << "\n"

      expect { Scorekeeper.keep_score(io) }.to output(expected_output).to_stdout
    end
  end
end
