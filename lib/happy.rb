require 'active_support/all' # SMELL

require 'happy/context'
require 'happy/controller'
require 'happy/static'

module Happy
  class HappyError < StandardError ; end
  class NotFoundError < HappyError ; end

  def self.env
    ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
  end
end
