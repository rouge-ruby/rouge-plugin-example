task :default => :spec

task :spec do
  require_relative "spec/spec_helper"
  FileList["spec/*_spec.rb"].each { |f| require_relative f }
end

task :server do
  require 'webrick'
  require 'rackup'

  Rackup::Server.start(config: 'config.ru', Port: '9292')
end
