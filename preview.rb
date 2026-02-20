#!/usr/bin/env ruby

require 'rouge'
require_relative 'lib/rouge/magritte'

fname = ARGV[0] || "#{__dir__}/spec/visual/samples/magritte"

if fname == 'demo'
  text = RougeMagritte::Magritte.demo
else
  text = File.read(fname)
end

Rouge::Lexer.enable_debug!

if ENV['DEBUG'] == '1'
  lexer = RougeMagritte::Magritte.new(debug: true)
  formatter = 'null'
else
  lexer = RougeMagritte::Magritte.new
  formatter = 'terminal_truecolor'
end

Rouge.highlight(text, lexer, formatter) { |chunk| print chunk }
