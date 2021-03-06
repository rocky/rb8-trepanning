# -*- coding: utf-8 -*-
# Copyright (C) 2010, 2011 Rocky Bernstein <rockyb@rubyforge.net>
require 'rubygems'; require 'require_relative'
require_relative '../command'
# require_relative '../breakpoint'
# require_relative '../../app/breakpoint'

# disable breakpoint command. The difference however is that the
# parameter to @proc.en_disable_breakpoint_by_number is different (set
# as ENABLE_PARM below).
#
# NOTE: The enable command  subclasses this, so beware when changing! 
class Trepan::Command::DisableCommand < Trepan::Command

  Trepan::Util.suppress_warnings {
    NAME = File.basename(__FILE__, '.rb')
    HELP = <<-HELP
#{NAME} NUM1 [NUM2 ...]
    
Disables the breakpoints given as a space-separated list of
numbers. 

See also "enable" and "info break".
  HELP

    CATEGORY      = 'breakpoints'
    SHORT_HELP    = 'Disable some breakpoints'
  }

  def initialize(proc)
    super
    @enable_parm = false # true if enable 
  end
  
  def enable_disable_breakpoints(is_enable, args)
    breakpoints = Debugger.breakpoints.sort_by{|b| b.id }
    largest = breakpoints.inject(0) do |largest, b| 
      largest = b.id if b.id > largest
    end
    if 0 == largest
      errmsg "No breakpoints have been set.\n"
      return
    end
    args.each do |num_str|
      pos = @proc.get_an_int(num_str)
      return nil unless pos
      breakpoints.each do |b|
        if b.id == pos 
          enabled = ("Enable" == is_enable)
          if enabled
            unless syntax_valid?(b.expr)
              errmsg("Expression \"#{b.expr}\" syntactically incorrect; breakpoint remains disabled.\n")
              break
            end
          end
          b.enabled = ("Enable" == is_enable)
          break
        end
      end
    end
  end

  def run(args)
    if args.size == 1
      errmsg('No breakpoint number given.')
      return
    end
    enable_disable_breakpoints("Disable", args[1..-1])
  end

end    
        
if __FILE__ == $0
  require_relative '../mock'
  dbgr, cmd = MockDebugger::setup
  cmd.run([cmd.name])
  cmd.run([cmd.name, '1'])
  cmds = cmd.proc.commands
  puts "To be continued..."
# 
#  break_cmd = cmds['break']
#  break_cmd.run(['break', cmdproc.frame.line])
#  cmd.run([cmd.name, '1'])
end
