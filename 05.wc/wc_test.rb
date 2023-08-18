require 'test/unit'
require './wc'


class TC_Wc < Test::Unit::TestCase
  #TODO オプションが1つの場合
  ##l option
  def l_option
    file = "l_option.md"
    file_data = ""
    l_total = []
    output_expect = "expect"
    l_total_expect = "expect"

    output,l_total = l_option(file_data,file,l_total)
    assert_equal(output, output_expect)
    assert_equal(l_total, l_total_expect)
  end

  ##w option
  def w_option
    file = "w_option.md"
    file_data = ""
    w_total = []
    output_expect = "expect"
    w_total_expect = "expect"

    output,w_total = w_option(file_data,file,w_total)
    assert_equal(output, output_expect)
    assert_equal(w_total, w_total_expect)
  end

  ##c option
  def c_option
    file = "c_option.md"
    file_path = ""
    c_total = []
    output_expect = "expect"
    c_total_expect = "expect"

    output,c_total = c_option(file_path,file,c_total)
    assert_equal(output, output_expect)
    assert_equal(c_total, c_total_expect)
  end

  #TODO オプションが2つの場合
  ##lwまたはwl
  def lw_wl_option
    file = "wc_test.md"
    file_data = ""
    l_total = []
    w_total = []
    output_expect = "expect"
    l_total_expect = "expect"
    w_total_expect = "expect"

    output, l_total, w_total = l_and_w_option(file_data,file,l_total,w_total)
    assert_equal(output, output_expect)
    assert_equal(l_total, l_total_expect)
    assert_equal(w_total, w_total_expect)
  end

  ##wcまたはcw
  def wc_cw_option
    file = "wc_test.md"
    file_data = ""
    file_path = ""
    w_total = []
    c_total = []
    output_expect = "expect"
    w_total_expect = "expect"
    c_total_expect = "expect"

    output, w_total, c_total = w_and_c_option(file_path,file_data,file,w_total,c_total)
    assert_equal(output, output_expect)
    assert_equal(w_total, w_total_expect)
    assert_equal(c_total, c_total_expect)
  end

  ##clまたはlc
  def cl_lc_option
    file = "wc_test.md"
    file_data = ""
    file_path = ""
    c_total = []
    l_total = []
    output_expect = "expect"
    c_total_expect = "expect"
    l_total_expect = "expect"

    output, c_total, l_total = c_and_l_option(file_path,file_data,file,c_total,l_total)
    assert_equal(output, output_expect)
    assert_equal(c_total, c_total_expect)
    assert_equal(l_total, l_total_expect)
  end

  #TODO オプション無しまたは3つの場合
  def l_and_w_and_c_option
    file = "wc_test.md"
    file_data = ""
    file_path = ""
    l_total = []
    w_total = []
    c_total = []
    output_expect = "expect"
    l_total_expect = "expect"
    w_total_expect = "expect"
    c_total_expect = "expect"

    output,l_total,w_total,c_total = l_and_w_and_c_option(file_path,file_data,file,l_total,w_total,c_total)
    assert_equal(output, output_expect)
    assert_equal(l_total, l_total_expect)
    assert_equal(w_total, w_total_expect)
    assert_equal(c_total, c_total_expect)
  end
end
