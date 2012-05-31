SPEC_DIR = File.dirname(__FILE__)
lib_path = File.expand_path("#{SPEC_DIR}/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'rubygems'
require 'bundler/setup'
require 'rack/test'

require 'happy'

module SpecHelpers
  def app
    subject
  end

  def response_for
    yield if block_given?
    last_response
  end
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include SpecHelpers
end
