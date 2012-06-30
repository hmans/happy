require 'tilt'

module Happy
  module Helpers
    module Rendering
      attr_accessor :output_buffer

      # Renders "something". This method takes a closer look at what this
      # "something" is and then dispatches to a more specific method.
      #
      def render(what, *args, &blk)
        case what
          when NilClass   then ''
          when String     then render_template(what, *args, &blk)
          when Enumerable then what.map { |i| render(i, *args, &blk) }.join
          else render_resource(what, *args)
        end
      end

      # Render a template from the controller's view folder.
      #
      def render_template(name, variables = {}, engine_options = {}, &blk)
        path = settings[:views] || './views'
        full_name = File.expand_path(File.join(path, name))

        # load and cache template
        @@cached_templates ||= {}
        t = @@cached_templates[full_name] =
          (Happy.env.production? && @@cached_templates[full_name]) || begin
            engine_options = {
              :default_encoding => 'utf-8',
              :outvar => "@output_buffer"    # for erb
            }.merge(engine_options)
            Tilt.new(full_name, engine_options)
          end

        # render template
        t.render(self, variables, &blk)
      end

      # Render a resource.
      #
      def render_resource(resource, options = {})
        # build name strings
        singular_name = resource.class.to_s.tableize.singularize
        plural_name   = singular_name.pluralize

        # set options
        options = {
          singular_name => resource
        }.merge(options)

        # render
        render_template("#{plural_name}/_#{singular_name}.html.haml", options)
      end


      # Capture a block from a template. Use this inside view helpers that
      # take blocks.
      #
      def capture_template_block(*args, &blk)
        if respond_to?(:is_haml?) && is_haml?
          capture_haml(*args, &blk)
        else
          with_output_buffer(&blk)
        end
      end

      # Add something to the output being rendered by the current template.
      # Use this inside view helpers that take blocks.
      #
      def concat_output(v)
        if respond_to?(:is_haml?) && is_haml?
          v
        else
          self.output_buffer << v
        end
      end

      # Execute the given block, adding its generated output to a new view
      # buffer, and finally returning that buffer. Use this inside view helpers
      # that take blocks.
      #
      def with_output_buffer
        self.output_buffer, old_buffer = "", self.output_buffer
        yield if block_given?
        output_buffer
      ensure
        self.output_buffer = old_buffer
      end

    end
  end
end
