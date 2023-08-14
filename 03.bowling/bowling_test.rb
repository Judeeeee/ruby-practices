require 'test/unit'
require './bowling'

class TestBowling < Test::Unit::TestCase

  #TODO `convert_input`のテスト
  #以下の要素をクリアさせるためのテストケース
  #(1) Xが[10,0]に置き換わること
  #(2)要素が2つで分割されていること
  def test_convert_input_1
    input = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5"
    flame = convert_input(input)
    expect = [[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[6,4,5]]
    assert_equal(flame,expect)
  end

  def test_convert_input_2
    input = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X"
    flame = convert_input(input)
    expect = [[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[10,10,10]]
    assert_equal(flame,expect)
  end

  def test_convert_input_3
    input = "0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4"
    flame = convert_input(input)
    expect = [[0,10],[1,5],[0,0],[0,0],[10,0],[10,0],[10,0],[5,1],[8,1],[0,4]]
    assert_equal(flame,expect)
  end

  def test_convert_input_4
    input = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0"
    flame = convert_input(input)
    expect = [[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[10]]
    assert_equal(flame,expect)
  end

  def test_convert_input_5
    input = "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8"
    flame = convert_input(input)
    expect = [[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[10,1,8]]
    assert_equal(flame,expect)
  end

  def test_convert_input_6
    input = "X,X,X,X,X,X,X,X,X,X,X,X"
    flame = convert_input(input)
    expect = [[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,10,10]]
    assert_equal(flame,expect)
  end

  def test_convert_input_7
    input = "X,0,0,X,0,0,X,0,0,X,0,0,X,0,0"
    flame = convert_input(input)
    expect = [[10,0],[0,0],[10,0],[0,0],[10,0],[0,0],[10,0],[0,0],[10,0],[0,0]]
    assert_equal(flame,expect)
  end

  # #####TODO `calculate_score`のテスト
  def test_calculate_score_1
    flames = [[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[6,4,5]]
    acutual = calculate_score(flames)
    expected = 139
    assert_equal(acutual,expected)
  end

  def test_calculate_score_2
    flames = [[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[10,10,10]]
    acutual = calculate_score(flames)
    expected = 164
    assert_equal(acutual,expected)
  end

  def test_calculate_score_3#![0,10]はスペアだけどどうするか
    flames = [[0,10],[1,5],[0,0],[0,0],[10,0],[10,0],[10,0],[5,1],[8,1],[0,4]]
    acutual = calculate_score(flames)
    expected = 107
    assert_equal(acutual,expected)
  end

  def test_calculate_score_4
    flames = [[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[10]]
    acutual = calculate_score(flames)
    expected = 134
    assert_equal(acutual,expected)
  end

  def test_calculate_score_5
    flames = [[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[10,1,8]]
    acutual = calculate_score(flames)
    expected = 144
    assert_equal(acutual,expected)
  end

  def test_calculate_score_6#!actual:220
    flames =  [[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,10,10]]
    acutual = calculate_score(flames)
    expected = 300
    assert_equal(acutual,expected)
  end

  def test_calculate_score_7
    flames = [[10,0],[0,0],[10,0],[0,0],[10,0],[0,0],[10,0],[0,0],[10,0],[0,0]]
    acutual = calculate_score(flames)
    expected = 50
    assert_equal(acutual,expected)
  end
end
