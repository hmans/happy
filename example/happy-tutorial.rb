# ## Introduction

# Welcome to the **Happy Tutorial**!
#
# Happy is a framework that offers a significantly
# different approach to developing web applications from that of Ruby on Rails,
# Sinatra and most other Ruby web frameworks available.
#
# Let's jump right in!
#
module HappyTutorial

  # ### A Note about this tutorial
  #
  # This tutorial is actually a fully functional Happy application. Start
  # it by issuing the following commands inside the `example/` directory:
  #
  #     bundle install
  #     bundle exec rackup
  #
  # The application will then be running on [http://localhost:9292](http://localhost:9292).

  # ## Happy Controllers

  # Pretty much everything you develop with Happy will be some class derived from
  # [Happy::Controller](http://rdoc.info/github/hmans/happy/master/Happy/Controller).
  # In this tutorial, you will notice that we will be creating a whole bunch of
  # these classes, wrapping individual lessons.
  # Happy controllers are discrete applications that can be mounted as Rack
  # apps or invoked from within other Happy Controllers.
  #
  # Unlike controllers in Rails, Happy controllers describe functionality, not
  # individual resources; they can be very simple (eg. serving a simple string, like above),
  # or very complex (eg. serving a complete admin backend, blog engine or similar).
  # Happy leaves it up to you
  # to modularize your application's functionality into controllers small and big.
  #
  # ### The `#route` method
  #
  # Every Happy controller defines a `#route` method that is called for
  # every incoming request. This is a significant departure from how you develop
  # with, for example, Rails, where every requested URL is mapped to a specific
  # piece of code through routes defined in a separate configuration file.
  #
  # Within the `#route` method, it is then expected that you, somehow, handle the
  # request. Make it return a string, that string will be returned to the requesting
  # client as the response. Of course, there's a whole lot more you can do within
  # that method; but more on that later.

  # Let's start with a
  # simple "Hello world" style example.

  class HelloWorldExample < Happy::Controller
    def route
      "Hello, world!"
    end
  end


  # ### Handling URLs

  # Obviously, your app should be able to do a lot more than just display
  # a string of text at its root URL. Fret not, for Happy gives you powerful
  # tools to create pretty much any URL structure you can think of.
  #
  # Happy provides the `#on` method that allows you to provide code that
  # is only executed if a matching URL is requested. These can be nested,
  # too; for example, this block of code will handle the `/foo` and `/foo/bar`
  # URLs.
  #
  class RoutingExample < Happy::Controller
    def route
      on 'foo' do
        on 'bar' do
          "You requested foo and bar!"
        end

        "You requested just foo!"
      end

      "You requested this controller's root URL!"
    end
  end

  # ### Handling HTTP Verbs

  # In addition to `#on`, Happy also provides `#on_get`, `#on_post`, `#on_put` and `#on_delete`,
  # which work just like `#on`, except they also check for the specified HTTP verb (GET, POST,
  # PUT or DELETE).
  #
  class HttpVerbRoutingExample < Happy::Controller
    def route
      on_get('foo') { "You did a GET request on foo!" }
      on_post('foo') { "You did a POST request on foo!" }

      # Note that the actual path parameter is optional, so this will work as well:
      on 'bar' do
        on_get  { "You did a GET request on bar!" }
        on_post { "You did a POST request on bar!" }
      end

      # The `#current_url` method will return the current URL plus an optional suffix.
      # This is great for building relative links within your controller.
      "Try GET and POST on #{current_url('foo')} and #{current_url('bar')}!"
    end
  end

  # ### Dealing with Request Parameters

  # Inside a Happy controller, the `#params` method will allow you to access the
  # request parameters. In addition, you can use placeholders inside path names
  # to retrieve parameters from the actual URLs requested.
  class PathParameterExample < Happy::Controller
    def route
      on 'hello' do
        on :name do
          "Hello, #{params['name']}!"
        end

        "You didn't provide a name. :/"
      end

      # You can even use inline placeholders within a path:
      on 'hi-:name' do
        "Hi, #{params['name']}!"
      end

      "Try #{link_to current_url('hello/joe')} or #{link_to current_url('hi-joe')}!"
    end
  end

  # ### Structuring Happy Controllers

  # Since controllers are just normal Ruby classes, you can use all the tools you
  # know from Ruby to structure your application. For example, it is recommended
  # to move the actual logic of your actions to separate methods, and just call
  # those methods from within the on blocks. This makes your controllers easier
  # to maintain and test. Here's an example:

  class MethodExample < Happy::Controller
    def route
      on('users')  { list_users }
      on('images') { list_images }
      homepage
    end

    def homepage
      "This is the homepage!"
    end

    def list_users
      "This is a list of users."
    end

    def list_images
      "This is a list of images."
    end
  end



  # ## Rendering Responses

  # ### Rendering Templates
  # _TODO_

  # ### Setting Headers
  # _TODO_

  # ### Caching
  # _TODO_

  # ### Rendering Objects
  # _TODO_

  # ## Helpers

  # ### What are helpers?
  # _TODO_

  # ### Built-in helpers
  # _TODO_

  # ### Writing your own helpers
  # _TODO_

# The end.
end
