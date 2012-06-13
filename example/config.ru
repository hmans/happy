# Just run this script through the 'rackup' command.

lib_path = File.expand_path("#{File.dirname(__FILE__)}/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'happy'

# Controllers are the core building blocks of Happy applications.
# They're also just Rack apps, so in any Happy app, you will
# declare at least a "root" controller class and run that through Rack.

class TestApp < Happy::Controller

  # A controller's most important method is #route. Whenever a request hits
  # your application, a new instance of your root controller class is
  # created, and its #route method is called.
  #
  # This method can be as simple or complex as you like. In this example
  # application, it wraps around a couple of annotated Happy examples.
  # Usually, you'd use the #path? method to specify code to be executed if
  # a certain path was requested; in this app, we're using a custom #example
  # method, that does the same thing but also records the example in a hash
  # so we can generated a "table of contents" in index.erb.

  def route
    example 'Returning just a string' do
      "I'm just a string!"
    end

    example 'Explicit responses' do
      serve! "I was served through #serve!"
      serve! "I'm not being served, since the above call to #serve! halted processing."
    end

    example 'Content-type' do
      content_type 'text/css'
      "/* I'm CSS! */\n\nbody { color: red }\n"
    end

    example 'Path parameters' do
      path? 'hello' do
        path? :name do
          "Hello, #{params['name']}!"
        end
      end

      "Try #{link_to 'this', current_url('hello', 'hendrik')}!"
    end

    example 'Inline path parameters' do
      path? 'hello-:name' do
        "Hello, #{params['name']}!"
      end

      "Try #{link_to 'this', current_url('hello-hendrik')}!"
    end

    example 'Permissions' do
      # set up permissions ;-)
      can.dance!

      path? 'dance' do
        if can.dance?
          "You can dance."
        else
          "You can not dance."
        end
      end

      "Can you #{link_to 'dance', current_url('dance')}?"
    end

    example 'Layouts' do
      path? 'with-layout' do
        layout 'layout.erb'

        path? 'changed-my-mind' do
          layout false
          "This should render without a layout."
        end

        "This should render with a layout."
      end

      "This should render without a layout."
    end

    example 'Invoking other controllers' do
      # creata new controller on the fly
      c = Happy.route do
        "Controller wrapping works, yay!"
      end

      # pass control over the request to that controller
      run c
    end

    example 'Invoking Rack apps' do
      # define a Rack app
      rackapp = lambda { |env| [200, {'Content-type' => 'text/html'}, ["It works!"]] }

      # pass control over the request to the Rack application
      run rackapp
    end

    example 'Errors' do
      null = Happy::Controller.new

      # Trigger an error. This should display a nice error page.
      null.foobar
    end

    render 'index.erb'
  end

  def examples; @examples ||= {}; end

  def example(name, path_name = nil, &blk)
    path_name ||= name.parameterize
    examples[name] = path_name

    # Create a path containing the example's code block
    path?(path_name, &blk)
  end
end

run TestApp
