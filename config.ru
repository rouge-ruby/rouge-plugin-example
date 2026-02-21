require 'rouge'

run do |env|
  # hot reload our lexer
  Object.send(:remove_const, :RougeMagritte) if defined?(::RougeMagritte)
  $LOADED_FEATURES.reject! { |f| f.start_with?(File.expand_path(__dir__)) }
  require_relative 'lib/rouge/magritte'

  # build response
  body = []

  input = File.read(ENV["SAMPLE_FILE"] || "#{__dir__}/spec/visual/samples/magritte")

  body << '<!DOCTYPE html><html><head>'

  # <head> tag
  body << '<style type="text/css">'
  body << Rouge::Themes::ThankfulEyes.new(scope: '.container').render
  body << <<~CSS
    body { background-color: black; }
    .container { white-space: pre; font-family: monospace; padding: 20px; }
  CSS
  body << '</style>'

  # <body> tag
  body << '</head><body>'
  html = Rouge.highlight(input, 'magritte', Rouge::Formatters::HTML.new)
  body << '<div class="container">'
  body << html
  body << '</div></body></html>'

  # output response
  [200, {}, body]
end
