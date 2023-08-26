require 'test/unit'
require './wc'

#TODO: expectの値を変える

class TC_Wc < Test::Unit::TestCase
  def l_option
    opt = OptionParser.new
    params = {}
    opt.on('-l') {|v| params[:l] = v }
    opt.on('-w') {|v| params[:w] = v }
    opt.on('-c') {|v| params[:c] = v }
    opt.parse!(ARGV)

    files = ["l_option.md"]
    l_total, w_total, c_total, output = calcurate_data(files, params)
    output_expect = "5 l_option.md"
    l_total_expect = [5]
    assert_equal(output, output_expect)
    assert_equal(l_total, l_total_expect)
  end

  ##w option
  def w_option
    opt = OptionParser.new
    params = {}
    opt.on('-l') {|v| params[:l] = v }
    opt.on('-w') {|v| params[:w] = v }
    opt.on('-c') {|v| params[:c] = v }
    opt.parse!(ARGV)

    files = ["w_option.md"]
    l_total, w_total, c_total, output = calcurate_data(files, params)
    output_expect = "5 w_option.md"
    w_total_expect = [5]

    assert_equal(output, output_expect)
    assert_equal(w_total, w_total_expect)
  end

  ##c option
  def c_option
    opt = OptionParser.new
    params = {}
    opt.on('-l') {|v| params[:l] = v }
    opt.on('-w') {|v| params[:w] = v }
    opt.on('-c') {|v| params[:c] = v }
    opt.parse!(ARGV)

    files = ["c_option.md"]
    l_total, w_total, c_total, output = calcurate_data(files, params)
    output_expect = "5 c_option.md"
    c_total_expect = [5]

    assert_equal(output, output_expect)
    assert_equal(c_total, c_total_expect)
  end

  #TODO オプションが2つの場合
  ##lwまたはwl
  def lw_wl_option
    opt = OptionParser.new
    params = {}
    opt.on('-l') {|v| params[:l] = v }
    opt.on('-w') {|v| params[:w] = v }
    opt.on('-c') {|v| params[:c] = v }
    opt.parse!(ARGV)

    files = [["l_option.md"],["w_option.md"]]
    l_total, w_total, c_total, output = calcurate_data(files, params)
    output_expect = "expect"
    l_total_expect = "expect"
    w_total_expect = "expect"
    assert_equal(output, output_expect)
    assert_equal(l_total, l_total_expect)
    assert_equal(w_total, w_total_expect)
  end

  ##wcまたはcw
  def wc_cw_option
    opt = OptionParser.new
    params = {}
    opt.on('-l') {|v| params[:l] = v }
    opt.on('-w') {|v| params[:w] = v }
    opt.on('-c') {|v| params[:c] = v }
    opt.parse!(ARGV)

    files = [["w_option.md"],["c_option.md"]]
    l_total, w_total, c_total, output = calcurate_data(files, params)
    output_expect = "expect"
    w_total_expect = "expect"
    c_total_expect = "expect"

    assert_equal(output, output_expect)
    assert_equal(w_total, w_total_expect)
    assert_equal(c_total, c_total_expect)
  end

  ##clまたはlc
  def cl_lc_option
    opt = OptionParser.new
    params = {}
    opt.on('-l') {|v| params[:l] = v }
    opt.on('-w') {|v| params[:w] = v }
    opt.on('-c') {|v| params[:c] = v }
    opt.parse!(ARGV)

    files = [["c_option.md"],["l_option.md"]]
    l_total, w_total, c_total, output = calcurate_data(files, params)
    output_expect = "expect"
    c_total_expect = "expect"
    l_total_expect = "expect"

    assert_equal(output, output_expect)
    assert_equal(c_total, c_total_expect)
    assert_equal(l_total, l_total_expect)
  end

  #TODO オプション無しまたは3つの場合
  def l_and_w_and_c_option
    opt = OptionParser.new
    params = {}
    opt.on('-l') {|v| params[:l] = v }
    opt.on('-w') {|v| params[:w] = v }
    opt.on('-c') {|v| params[:c] = v }
    opt.parse!(ARGV)

    files = [["l_option.md"],["w_option.md"],["c_option.md"]]
    l_total, w_total, c_total, output = calcurate_data(files, params)
    output_expect = "expect"
    l_total_expect = "expect"
    w_total_expect = "expect"
    c_total_expect = "expect"

    total = total_output(l_total, w_total, c_total)
    total_expect = ""

    assert_equal(output, output_expect)
    assert_equal(l_total, l_total_expect)
    assert_equal(w_total, w_total_expect)
    assert_equal(c_total, c_total_expect)
    assert_equal(total, total_expect)
  end
end
