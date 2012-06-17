module Happy
  module Extras
    class Static < Happy::Controller
      def route
        run Rack::File.new(settings[:path])
      end
    end
  end
end
