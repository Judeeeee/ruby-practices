# frozen_string_literal: true

require 'test/unit'
require './bowling'

class TestBowling < Test::Unit::TestCase
  def test_case_1
    scoreboard = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    frames = split_by_frames(scoreboard)
    final_score = calculate_score(frames)
    expected = 139
    assert_equal(final_score, expected)
  end

  def test_case_2
    scoreboard = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    frames = split_by_frames(scoreboard)
    final_score = calculate_score(frames)
    expected = 164
    assert_equal(final_score, expected)
  end

  def test_case_3
    scoreboard = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    frames = split_by_frames(scoreboard)
    final_score = calculate_score(frames)
    expected = 107
    assert_equal(final_score, expected)
  end

  def test_case_4
    scoreboard = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    frames = split_by_frames(scoreboard)
    final_score = calculate_score(frames)
    expected = 134
    assert_equal(final_score, expected)
  end

  def test_case_5
    scoreboard = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    frames = split_by_frames(scoreboard)
    final_score = calculate_score(frames)
    expected = 144
    assert_equal(final_score, expected)
  end

  def test_case_6
    scoreboard = 'X,X,X,X,X,X,X,X,X,X,X,X'
    frames = split_by_frames(scoreboard)
    final_score = calculate_score(frames)
    expected = 300
    assert_equal(final_score, expected)
  end

  def test_case_7
    scoreboard = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'
    frames = split_by_frames(scoreboard)
    final_score = calculate_score(frames)
    expected = 50
    assert_equal(final_score, expected)
  end
end
