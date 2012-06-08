require 'happy/request'
require 'happy/context/helpers'

module Happy
  # Represents the current request and its respective application state.
  # Not only does this class wrap around both the incoming {#request} and the
  # generated {#response}, but it is also used as the scope for all templates
  # rendered through {#render_template}.
  #
  # (In case you're wondering, a particular request's instance of #{Context} is
  # created from the Rack environment by #{Controller#context} when first accessed.)
  #
  # == View Helpers
  #
  # If you're coming from other web frameworks and looking for the right place
  # to add "view helpers", this is it, since all templates being rendered use
  # the request's instance of {Context} as their scope.
  #
  # The most convenient way of extending this class is through #{Happy.context}.
  #
  #     Happy.context do
  #       def some_helper
  #         "I'm a view helper!"
  #       end
  #     end
  #
  # In addition to view helpers, the context is the place to add methods
  # dealing with the current request scope, eg. methods like 'current_user'.
  #
  class Context
    include Helpers

    # Instance of {Happy::Request} representing the current HTTP request.
    attr_reader :request

    # The Rack::Response instance being used to compose the response.
    attr_accessor :response

    # The current layout template to be used when rendering the response.
    attr_accessor :layout

    # Array containing path parts that are yet to be handled.
    attr_reader :remaining_path

    # Array of path parts that have been handled so far.
    attr_reader :previous_path

    delegate :params, :session, :to => :request

    # Initializes a new {Context} instance from a Rack environment hash.
    #
    # @param [Hash] env Rack environment hash
    #
    def initialize(env)
      @request        = Happy::Request.new(env)
      @response       = Rack::Response.new

      @remaining_path = @request.path.split('/').reject {|s| s.blank? }
      @previous_path  = []
      @layout         = nil
      @controller     = nil
    end

    # @note
    #   This method is mostly used internally by Happy. You will not need
    #   to call it from your own controllers or applications.
    #
    # Execute the provided block, but register the provided {Controller}
    # instance as the controller currently handling the request. Call this
    # whenever you're passing control from one controller to another.
    #
    # @param [Controller] new_controller The {Controller} instance to set as the current controller
    # @return Results of provided block.
    #
    def with_controller(new_controller)
      # remember previous controller
      old_controller = @controller
      @controller = new_controller

      # execute block
      yield if block_given?
    ensure
      # switch back to previous controller
      @controller = old_controller
    end

  end
end
