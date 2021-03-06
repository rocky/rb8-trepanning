#!/usr/bin/env ruby
require 'rubygems'; require 'require_relative'
# require_relative '../../lib/trepanning'
require_relative 'helper'

# Test 'edit' command handling.
class TestEdit < Test::Unit::TestCase
  include TestHelper
  def test_basic
    common_setup(__FILE__)
    Dir.chdir(@srcdir) do 
      ENV['EDITOR']='echo FAKE-EDITOR '
      assert_equal(true,  
                   run_debugger(@testname, @prefix + '../example/gcd.rb 3 5'))
    end
  end
end
