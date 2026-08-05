require 'rouge'

run do |env|
  # hot reload our lexer
  Object.send(:remove_const, :RougeMagritte) if defined?(::RougeMagritte)
  $LOADED_FEATURES.reject! { |f| f.start_with?(File.expand_path(__dir__)) }
  require_relative 'lib/rouge-magritte'

  # put ?debug=1 in the url bar to print debugging info
  Rouge::Lexer.enable_debug!

  # build response
  body = []

  # load the info
  input = File.read(ENV["SAMPLE_FILE"] || "#{__dir__}/spec/sample")

  # use the query string for lexer options
  lexer = Rouge::Lexer.find_fancy("magritte?#{env['QUERY_STRING']}")
  formatter = Rouge::Formatters::HTMLDebug.new
  highlighted_html = formatter.format(lexer.lex(input))

  theme_css = Rouge::Themes::ThankfulEyes.new(scope: '.container').render

  # output response
  [200, {}, [<<~HTML]]
  <!DOCTYPE html>
  <html>
    <head>
      <style type="text/css">
        body {
          background-color: black;
        }
        .container {
          white-space: pre;
          font-family: monospace;
          padding: 20px;
        }
        #{theme_css}
      </style>
    </head>
    <body>
      <div class="container">#{highlighted_html}</div>
    </body>
  </html>
  HTML
end
