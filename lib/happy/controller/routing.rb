module Happy
  class Controller
    module Routing
      def path_to_regexp(path)
        # Since we want to be compatible with Ruby 1.8.7, we unfortunately can't use named captures like this:
        # Regexp.compile('^'+path.gsub(/\)/, ')?').gsub(/\//, '\/').gsub(/\./, '\.').gsub(/:(\w+)/, '(?<\\1>.+)')+'$')
        Regexp.compile('^'+path.gsub(/\)/, ')?').gsub(/\//, '\/').gsub(/\./, '\.').gsub(/:(\w+)/, '(.+)')+'$')
      end

      def path?(*args, &blk)
        options = (args.pop if args.last.is_a?(Hash)) || {}
        args = [nil] if args.empty?

        args.each do |name|
          # If a path name has been given, match it against the next request path part.
          if name.present?
            # convert symbols to ":foo" type string
            name = ":#{name}" if name.is_a?(Symbol)
            path_match = path_to_regexp(name).match(unprocessed_path.first)
          end

          # Match the request method, if specified
          method_matched = [nil, request.request_method.downcase.to_sym].include?(options[:method])

          path_matched   = (path_match || (name.nil? && unprocessed_path.empty?))

          # Only do something here if method and requested path both match
          if path_matched && method_matched
            # Transfer variables contained in path name to params hash
            if path_match
              name.scan(/:(\w+)/).flatten.each do |var|
                request.params[var] = path_match.captures.shift
              end
              processed_path << unprocessed_path.shift
            end

            serve!(instance_exec(&blk)) or raise Errors::NotFound
          end
        end
      end

      [:get, :post, :put, :delete].each do |method|
        define_method("#{method}?") do |*args, &blk|
          args.last.is_a?(Hash) ? args.last.merge(:method => method) : args.push(:method => method)
          path?(*args, &blk)
        end
      end
    end
  end
end
