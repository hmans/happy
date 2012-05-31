module Happy
  module ControllerExtensions
    module Routing
      def path_to_regexp(path)
        path = ":#{path}" if path.is_a?(Symbol)
        Regexp.compile('^'+path.gsub(/\)/, ')?').gsub(/\//, '\/').gsub(/\./, '\.').gsub(/:(\w+)/, '(?<\\1>.+)')+'$')
      end

      def path(*args, &blk)
        options = (args.pop if args.last.is_a?(Hash)) || {}
        args = [nil] if args.empty?

        args.each do |name|
          if name.present?
            path_match = path_to_regexp(name).match(remaining_path.first)
          end

          method_matched = [nil, request.request_method.downcase.to_sym].include?(options[:method])
          path_matched   = (path_match || (name.nil? && remaining_path.empty?))

          # Only do something here if method and requested path both match
          if path_matched && method_matched
            # Transfer variables contained in path name to params hash
            if path_match
              path_match.names.each { |k| request.params[k] = path_match[k] }
              remaining_path.shift
            end

            serve! instance_exec(&blk)

            # If we get here, #serve decided not to serve.
            raise Errors::NotFound
          end
        end
      end

      def get(*args, &blk)
        args.last.is_a?(Hash) ? args.last.merge(method: :get) : args.push(method: :get)
        path(*args, &blk)
      end

      def post(*args, &blk)
        args.last.is_a?(Hash) ? args.last.merge(method: :post) : args.push(method: :post)
        path(*args, &blk)
      end

      def put(*args, &blk)
        args.last.is_a?(Hash) ? args.last.merge(method: :put) : args.push(method: :put)
        path(*args, &blk)
      end

      def delete(*args, &blk)
        args.last.is_a?(Hash) ? args.last.merge(method: :delete) : args.push(method: :delete)
        path(*args, &blk)
      end
    end
  end
end
