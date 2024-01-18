# frozen_string_literal: true

require 'test/unit'
require './bowling_object'

class TestBowling < Test::Unit::TestCase
  def test_case1
    scoreboard = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    game = Game.create(scoreboard)
    expected = 139
    assert_equal(game.total_score, expected)
  end

  def test_case2
    scoreboard = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    game = Game.create(scoreboard)
    expected = 164
    assert_equal(game.total_score, expected)
  end

  def test_case3
    scoreboard = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    game = Game.create(scoreboard)
    expected = 107
    assert_equal(game.total_score, expected)
  end

  def test_case4
    scoreboard = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    game = Game.create(scoreboard)
    expected = 134
    assert_equal(game.total_score, expected)
  end

  def test_case5
    scoreboard = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    game = Game.create(scoreboard)
    expected = 144
    assert_equal(game.total_score, expected)
  end

  def test_case6
    scoreboard = 'X,X,X,X,X,X,X,X,X,X,X,X'
    game = Game.create(scoreboard)
    expected = 300
    assert_equal(game.total_score, expected)
  end

  def test_case7
    scoreboard = 'X,X,X,X,X,X,X,X,X,X,X,2'
    game = Game.create(scoreboard)
    expected = 292
    assert_equal(game.total_score, expected)
  end

  def test_case8
    scoreboard = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'
    game = Game.create(scoreboard)
    expected = 50
    assert_equal(game.total_score, expected)
  end
end
