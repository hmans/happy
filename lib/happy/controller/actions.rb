module Happy
  class Controller
    module Actions
      def serve!(data, options = {})
        only_if_path_matches do
          # Don't serve is data is not a string.
          return unless data.is_a?(String)

          # Mix in default options
          options = {
            :layout => context.layout
          }.merge(options)

          # Add status code from options
          response.status = options.delete(:status) if options.has_key?(:status)

          # Extract layout
          layout = options.delete(:layout)

          # Treat remaining options as headers
          options.each { |k, v| header k, v }

          # Apply layout, if available
          if layout
            data = render(layout) { data }
          end

          # Set response body and finish request
          response.body = [data]
          halt!
        end
      end

      def serve_or_404!(*args)
        serve!(*args)

        # If we get here, #serve! decided not to serve, so let's raise a 404.
        raise Errors::NotFound
      end

      def halt!(message = :done)
        only_if_path_matches do
          throw message
        end
      end

      def redirect!(to, status = 302)
        only_if_path_matches do
          header :location, url_for(to)
          response.status = status
          halt!
        end
      end

      def layout(name)
        context.layout = name
      end

      def content_type(type)
        header :content_type, type
      end

      def max_age(t, options = {})
        options = {
          :public => true,
          :must_revalidate => true
        }.merge(options)

        s = []
        s << 'public' if options[:public]
        s << 'must-revalidate' if options[:must_revalidate]
        s << "max-age=#{t.to_i}"

        cache_control s.join(', ')
      end

      def cache_control(s)
        header :cache_control, s
      end

      def header(name, value)
        name = name.to_s.dasherize.humanize if name.is_a?(Symbol)
        response[name] = value
      end

      def run(thing, options = {}, &blk)
        if thing.is_a?(Class) && thing.ancestors.include?(Happy::Controller)
          # Happy controllers!
          thing.new(env, options, &blk).perform
        elsif thing.respond_to?(:call)
          # Rack apps!
          context.response = thing.call(request.env)
          throw :done
        elsif thing.respond_to?(:to_s)
          thing.to_s
        else
          raise "Don't know how to run #{thing.inspect} :("
        end
      end


      private

      # Execute the provided block, unless there are still bits of
      # unprocessed path left (which indicates that the current path
      # is not the path the user requested.)
      #
      def only_if_path_matches
        return unless remaining_path.empty?

        yield if block_given?
      end
    end
  end
end
