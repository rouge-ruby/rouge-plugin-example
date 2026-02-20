# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "rouge-magritte"
  s.version = "0.0.1"
  s.authors = ["Jeanine Adkisson"]
  s.email = ["jneen@jneen.ca"]
  s.summary = "A Magritte language plugin for Rouge"
  s.description = <<-desc.strip.gsub(/\s+/, ' ')
    Support for the Magritte language (files.jneen.ca/academic/thesis.pdf) for Rouge
  desc

  s.homepage = "https://github.com/rouge-ruby/rouge-plugin-example"
  s.files = Dir['Gemfile', 'LICENSE', 'rouge-magritte.gemspec', 'lib/**/*.rb']
  s.licenses = ['MIT', 'BSD-2-Clause']
  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'rouge', '~> 4.0'
end
