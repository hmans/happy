module Happy
  module Extras
    class CodeReloader < Happy::Controller
      class << self
        def reload_app_code
          Dir[config[:directory]].each do |f|
            load f
          end
          @app_code_loaded = true
        end

        def reload_app_code?
          Happy.env.development? || !@app_code_loaded
        end
      end

      def route
        raise "no directory specified" unless config[:directory]
        raise "no controller specified" unless config[:controller]

        self.class.reload_app_code if self.class.reload_app_code?
        run eval(config[:controller])
      end
    end
  end
end
