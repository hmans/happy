require 'happy-helpers/utils/date_parameter_converter'

module Happy
  class Request < Rack::Request
  protected

    def parse_query(qs)
      super(qs).tap do |p|
        HappyHelpers::Utils::DateParameterConverter.convert!(p)
      end
    end
  end
end
