module Happy
  class Controller
    module Rackable
      extend ActiveSupport::Concern

      def handle_request
        r = catch :done do
          serve!(route) or raise Errors::NotFound
        end

        r ||response

      rescue Errors::NotFound => e
        html = Errors.html e, self,
          :title => "Path not found",
          :message => '',
          :friendly_message => "You performed a <strong>#{request.request_method}</strong> request on <strong>#{request.path}</strong>, but your application did not know how to handle this request."
        [404, {'Content-type' => 'text/html'}, [html]]

      rescue ::Exception => e
        html = Errors.html e, self
        [500, {'Content-type' => 'text/html'}, [html]]
      end

      module ClassMethods
        def call(env)
          new(env).handle_request
        end
      end
    end
  end
end
