module Happy
  class Controller
    module Rackable
      extend ActiveSupport::Concern

      def handle_request
        catch :done do
          serve!(perform) or raise Errors::NotFound
        end

        response
      rescue Errors::NotFound => e
        html = Errors.html e, env,
          :title => "Path not found",
          :message => '',
          :friendly_message => "You performed a <strong>#{context.request.request_method}</strong> request on <strong>#{context.request.path}</strong>, but your application did not know how to handle this request."
        [404, {'Content-type' => 'text/html'}, [html]]
      rescue ::Exception => e
        html = Errors.html e, env
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
