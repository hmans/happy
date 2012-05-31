module Happy
  module Extensions
    class Static < Happy::Controller
      def route
        run Rack::File.new(options[:path])
      end
    end
  end
end
