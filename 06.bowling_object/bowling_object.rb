# frozen_string_literal: true

require './shot'
require './frame'
require './game'

def main
  game = Game.create(ARGV[0])
  puts game.total_score
end

main if __FILE__ == $PROGRAM_NAME
