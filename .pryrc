# Alieases for debugger.
if defined?(PryByebug) || defined?(PryDebugger)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

# Inspect hashes with 1.9 syntax and aligned to the left.
require 'ap'
Pry.config.print = proc do |_output, value|
  ap = AwesomePrint::Inspector.new(indent: -2, ruby19_syntax: true)
  pager = Pry.new.pager
  pretty = ap.awesome(value)
  pager.page "=> #{pretty}"
end
