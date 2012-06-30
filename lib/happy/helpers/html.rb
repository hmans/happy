require 'cgi'

module Happy
  module Helpers
    module Html
      def html_tag(name, options = nil, escape = true, &block)
        "<#{name} #{html_tag_attributes(options, escape) if options}#{block_given? ? ">#{yield if block_given?}</#{name}>" : " />"}"
      end

      def html_tag_attributes(options, escape = true)
        options.map do |k,v|
          if v
            v == true ? "#{k}" : "#{k}=\"#{ escape_html(v) }\""
          end
        end.compact.join(" ")
      end

      def escape_html(t)
        # Rack::Utils.escape_html(t.to_s)
        CGI::escape_html(t.to_s)
      end

      def preserve(t)
        t.chomp("\n").gsub(/\n/, '&#x000A;').gsub(/\r/, '')
      end

      def link_to(name, *target)
        options = target.last.is_a?(Hash) ? target.pop : {}
        target = name if target.empty?
        html_tag(:a, options.merge(:href => url_for(*target))) { name }
      end

      def url_for(*what)
        return what.first if what.size == 1 && what.first =~ %r{://}

        result = what.flatten.inject('') do |url, item|
          url << "/%s" % case item
            when String, Symbol then item.to_s
            when NilClass then "/"
            else "%s/%s" % [item.class.to_s.tableize.pluralize, item.try(:to_param) || item.try(:to_id) || item.try(:id)]
          end

          url
        end.gsub(/\/{2,}/, '/').chomp('/')

        result == "" ? '/' : result
      end
    end
  end
end
