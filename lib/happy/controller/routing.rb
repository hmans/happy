module Happy
  class Controller
    module Routing
      def path_to_regexp(path)
        # Since we want to be compatible with Ruby 1.8.7, we unfortunately can't use named captures like this:
        # Regexp.compile('^'+path.gsub(/\)/, ')?').gsub(/\//, '\/').gsub(/\./, '\.').gsub(/:(\w+)/, '(?<\\1>.+)')+'$')
        Regexp.compile('^'+path.gsub(/\)/, ')?').gsub(/\//, '\/').gsub(/\./, '\.').gsub(/:(\w+)/, '(.+)')+'$')
      end

      def path(*args, &blk)
        options = (args.pop if args.last.is_a?(Hash)) || {}
        args = [nil] if args.empty?

        args.each do |name|
          # If a path name has been given, match it against the next request path part.
          if name.present?
            # convert symbols to ":foo" type string
            name = ":#{name}" if name.is_a?(Symbol)
            path_match = path_to_regexp(name).match(remaining_path.first)
          end

          # Match the request method, if specified
          method_matched = [nil, request.request_method.downcase.to_sym].include?(options[:method])

          path_matched   = (path_match || (name.nil? && remaining_path.empty?))

          # Only do something here if method and requested path both match
          if path_matched && method_matched
            # Transfer variables contained in path name to params hash
            if path_match
              name.scan(/:(\w+)/).flatten.each do |var|
                request.params[var] = path_match.captures.shift
              end
              previous_path << remaining_path.shift
            end

            serve_or_404! instance_exec(&blk)
          end
        end
      end

      def get(*args, &blk)
        args.last.is_a?(Hash) ? args.last.merge(:method => :get) : args.push(:method => :get)
        path(*args, &blk)
      end

      def post(*args, &blk)
        args.last.is_a?(Hash) ? args.last.merge(:method => :post) : args.push(:method => :post)
        path(*args, &blk)
      end

      def put(*args, &blk)
        args.last.is_a?(Hash) ? args.last.merge(:method => :put) : args.push(:method => :put)
        path(*args, &blk)
      end

      def delete(*args, &blk)
        args.last.is_a?(Hash) ? args.last.merge(:method => :delete) : args.push(:method => :delete)
        path(*args, &blk)
      end
    end
  end
end
