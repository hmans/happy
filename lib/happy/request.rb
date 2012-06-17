require 'happy/request/date_parameter_converter'

module Happy
  # Happy's own little request class. It extends {Rack::Request} with
  # a bit of convenience functionality.
  #
  class Request < Rack::Request
    # Override the default #params method so it returns a Hash with indifferent
    # access if ActiveSupport is available.
    def params
      @env['happy.params'] ||= if defined?(HashWithIndifferentAccess)
        super.with_indifferent_access
      else
        super
      end
    end

  protected

    def parse_query(qs)
      super(qs).tap do |p|
        DateParameterConverter.convert!(p)
      end
    end
  end
end
