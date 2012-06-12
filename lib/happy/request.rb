# SMELL: really?
require 'happy-helpers/utils/date_parameter_converter'

module Happy
  # Happy's own little request class. It extends {Rack::Request} with
  # a bit of convenience functionality.
  #
  class Request < Rack::Request

  protected

    def parse_query(qs)
      super(qs).tap do |p|
        HappyHelpers::Utils::DateParameterConverter.convert!(p)
      end
    end
  end
end
