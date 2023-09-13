# frozen_string_literal: true

require 'test/unit'
require './bowling'

class TestBowling < Test::Unit::TestCase
  # split_by_framesのテスト
  def testcase1_split_by_frames
    input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    actual = split_by_frames(input)
    expect = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [6, 4], [5]]
    assert_equal(actual, expect)
  end

  def testcase2_split_by_frames
    input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    actual = split_by_frames(input)
    expect = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [10, 0], [10, 0], [10, 0]]
    assert_equal(actual, expect)
  end

  def testcase3_split_by_frames
    input = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    actual = split_by_frames(input)
    expect = [[0, 10], [1, 5], [0, 0], [0, 0], [10, 0], [10, 0], [10, 0], [5, 1], [8, 1], [0, 4]]
    assert_equal(actual, expect)
  end

  def testcase4_split_by_frames
    input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    actual = split_by_frames(input)
    expect = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [10, 0], [0, 0]]
    assert_equal(actual, expect)
  end

  def testcase5_split_by_frames
    input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    actual = split_by_frames(input)
    expect = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [10, 0], [1, 8]]
    assert_equal(actual, expect)
  end

  def testcase6_split_by_frames
    input = 'X,X,X,X,X,X,X,X,X,X,X,X'
    actual = split_by_frames(input)
    expect = [[10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0]]
    assert_equal(actual, expect)
  end

  def testcase7_split_by_frames
    input = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'
    actual = split_by_frames(input)
    expect = [[10, 0], [0, 0], [10, 0], [0, 0], [10, 0], [0, 0], [10, 0], [0, 0], [10, 0], [0, 0]]
    assert_equal(actual, expect)
  end

  # calculate_scoreのテスト
  def testcase1_calculate_score
    flames = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [6, 4, 5]]
    acutual = calculate_score(flames)
    expected = 139
    assert_equal(acutual, expected)
  end

  def testcase2_calculate_score
    flames = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [10, 10, 10]]
    acutual = calculate_score(flames)
    expected = 164
    assert_equal(acutual, expected)
  end

  def testcase3_calculate_score
    flames = [[0, 10], [1, 5], [0, 0], [0, 0], [10, 0], [10, 0], [10, 0], [5, 1], [8, 1], [0, 4]]
    acutual = calculate_score(flames)
    expected = 107
    assert_equal(acutual, expected)
  end

  def testcase4_calculate_score
    flames = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [10]]
    acutual = calculate_score(flames)
    expected = 134
    assert_equal(acutual, expected)
  end

  def testcase5_calculate_score
    flames = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [10, 1, 8]]
    acutual = calculate_score(flames)
    expected = 144
    assert_equal(acutual, expected)
  end

  def testcase6_calculate_score
    flames =  [[10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 10, 10]]
    acutual = calculate_score(flames)
    expected = 300
    assert_equal(acutual, expected)
  end

  def testcase7_calculate_score
    flames = [[10, 0], [0, 0], [10, 0], [0, 0], [10, 0], [0, 0], [10, 0], [0, 0], [10, 0], [0, 0]]
    acutual = calculate_score(flames)
    expected = 50
    assert_equal(acutual, expected)
  end
end
