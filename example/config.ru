lib_path = File.expand_path("#{File.dirname(__FILE__)}/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'happy'
require 'cgi'

class TestApp < Happy::Controller
  def example(name, path_name = nil, &blk)
    path_name ||= name.parameterize
    examples[name] = path_name
    path(path_name, &blk)
  end

  def examples
    @examples ||= {}
  end

  def route
    # set up permissions ;-)
    can.dance!

    example 'Invoking other controllers' do
      # creata new controller on the fly
      c = Happy.route do
        "Controller wrapping works, yay!"
      end

      # pass control over the request to that controller
      run c
    end

    example 'Errors' do
      null = Happy::Controller.new

      # Trigger an error
      null.foobar
    end

    example 'Path part parameters' do
      path 'hello' do
        path :name do
          "Hello, #{params['name']}!"
        end
      end

      "Try #{link_to 'this', current_url('hello', 'hendrik')}!"
    end

    example 'Permissions' do
      path 'dance' do
        if can.dance?
          "You can dance."
        else
          "You can not dance."
        end
      end

      "Can you #{link_to 'dance', current_url('dance')}?"
    end

    example 'Layouts' do
      path 'with-layout' do
        layout 'layout.erb'

        path 'changed-my-mind' do
          layout false
          "This should render without a layout."
        end

        "This should render with a layout."
      end

      "This should render without a layout."
    end

    example 'Returning just a string', 'returning-string' do
      "I'm just a string!"
    end

    render 'index.erb'
  end
end

run TestApp
