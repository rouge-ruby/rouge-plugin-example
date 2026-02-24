require 'rouge'

run do |env|
  # hot reload our lexer
  Object.send(:remove_const, :RougeMagritte) if defined?(::RougeMagritte)
  $LOADED_FEATURES.reject! { |f| f.start_with?(File.expand_path(__dir__)) }
  require_relative 'lib/rouge/magritte'

  # build response
  body = []

  input = File.read(ENV["SAMPLE_FILE"] || "#{__dir__}/spec/sample.mag")

  theme_css = Rouge::Themes::ThankfulEyes.new(scope: '.container').render
  highlighted_html = Rouge.highlight(input, 'magritte', Rouge::Formatters::HTML.new)

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
