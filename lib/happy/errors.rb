module Happy
  module Errors
    class Base < StandardError ; end
    class NotFound < Base ; end

    # Render a HTML page for the given exception.
    #
    # @param [Exception] exception
    #   The exception to display.
    # @param [Hash] env
    #   The current Rack environment hash (used to display information on request parameters, session contents and such.)
    #
    # @option options [String] :title
    #   Title of error page
    # @option options [String] :message
    #   Message to be displayed on error page, right underneath the title.
    # @option options [String] :friendly_message
    #   Friendly error message to be displayed below title and message.
    #   If left blank, will be generated from the exception message.
    #
    def self.html(exception, controller, options = {})
      options = {
        :title => exception.class.to_s,
        :message => exception.message,
        :friendly_message => nil
      }.merge(options)

      # Load and cache error template.
      @html = begin
        File.read(File.expand_path(File.join(__FILE__, '../files/error.erb')))
      end

      # Generate friendly message from exception.
      options[:friendly_message] ||= friendly_message_for options[:message]

      # Render error page.
      ERB.new(@html).result(binding)
    end

  protected

    def self.friendly_message_for(msg)
      case msg
      when /^undefined local variable or method `(.+)'/
        "You called a method called \"#{$1}\", and this method did not exist. This could simply be a typo. If it's not, please check that you're calling the method from within the correct scope."
      when /^undefined method `(.+)' for nil:NilClass$/
        "You called a method called <strong>\"#{$1}\"</strong> on <strong>nil</strong>. In most cases, this is due to simple typos; please check your variable names. Otherwise, make sure the receiving object has been initialized correctly."
      when /^undefined method `(.+)' for (.+)$/
        method = $1
        var = $2
        klass = case var
          when /^#<(.+):0x.+>$/ then $1
          when /^.+:(.+)$/ then $1
          else var
        end
        "You called a method called <strong>\"#{h method}\"</strong> on an instance of class <strong>#{h klass}</strong>, which doesn't know how to respond to that method. Please check for typos."
      end
    end

    def self.h(t) ; Rack::Utils.escape_html(t) ; end
  end
end
