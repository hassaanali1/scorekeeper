# Scorekeeper

This project takes an input stream of soccer matches, parses them and creates a
scoreboard which is displayed at the end of each match day.

## Design

<img width="746" alt="Screen Shot 2022-04-17 at 2 06 04 PM" src="https://user-images.githubusercontent.com/5578713/163730448-c5d0b65d-4c39-4af6-9d91-c5048f5b545d.png">


This program is set up with 4 main classes:

1) GameManager

This class does most of the work. It takes in games one by one and is responsible for adding up points, keeping track of teams and displaying the scoreboard at the end of each matchday. Since it does not have knowledge of the input stream, sometimes the `display_scoreboard` method must be called outside of the game manager.

2) Game

This class represents a game. It contains a set of teams and their scores. A class wasn't absolutely needed here but it is preferred since it can be added to later.

3) InputParser

This class takes an input string and validates it using a regex. If the line is
valid, a Game is created and passed back, otherwise nil.

4) Scorekeeper

This is the main class. It takes the input stream (ARGF) and runs each line of
input through the InputParser and then through the GameManager. There is a small amount of extra logic in it to deal with mid matchday interrupts and special cases.

### Notes
To take input, ruby's [ARGF](https://ruby-doc.org/core-2.5.0/ARGF.html) is used
which can handle piped input as well as reading from files. The ARGF input stream
is passed to the Scorekeeper.

`puts` is used to write to stdout. This could be improved by deciding on an output stream and passing it to the GameManager.

There are still rubocop warnings appearing in this project. The ones that are remaining are code recommendations that I may want to use to refactor later.

## Installation

To install the gem:

1) Install the required gems: `bundle install`
2) Build the .gem file: `rake build`
3) Install the gem: `rake install`

## Usage

This gem can be used by either passing the name of a text file as an argument or
piping input directly to the program.

The program only takes one argument but could be easily changed to take multiple. Underneath the hood it uses ruby's ARGF which can concatenate multiple files into one input stream.  

The command line interface also filters out any files that don't exist or are not .txt files.

Example usage:

1) `scorekeeper input_file.txt`
2) `cat sample_input_3.txt | scorekeeper`

## Assumptions

1) Team names only contain letters and numbers, no special characters. A name like
"Ottawa 67s" would work but not "Ottawa 67's"

2) The number of teams is not immense. This assumption comes from the requirement
"input data could be in the order of terabytes". This solution will work with
large files as long as there isn't a massive (gigabytes) amount of teams. The
number of teams and scores are stored in memory within a hash. If there is a
massive amount of unique values in the hash, the program could run out of memory
and crash. Allowing for a massive number of teams would require using a database
to store all the unique teams. The database would then also need to be indexed on
the points column so that the top teams could easily be stored. Also, at that
point you would need to have a hosted database (like on RDS) with a flexible
amount of storage which I felt was more trouble than it was worth for this project.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
