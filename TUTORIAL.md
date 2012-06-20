# The Happy Book of Happy

Welcome to the Happy Book of Happy, an introduction on how to develop web applications using Happy, a cute little web application toolkit for Ruby! Let's get straight to it, shall we?


----

## The Basics

### "Hello World" with Happy

So, without further ado, here's the Happy version of "Hello World":

``` ruby
# config.ru
require 'happy'

class MyApp < Happy::Controller
  def route
    "Hello World"
  end
end

run MyApp
```

You can run this example (assuming it's inside a file called config.ru) by simply issuing the `rackup` command. Try `rackup --help` for available options.


### Happy Controllers

So, the previous chapter's "Hello World" example isn't terribly exciting, but there's a couple of interesting things to note here.

First of all, note how you're creating a subclass of `Happy::Controller`. That class is central to how Happy works; pretty much everything you do in Happy revolves around controllers.

Unlike your may know it from frameworks like Ruby on Rails, controllers are really self-contained applications that describe behaviour. They can be very simple (simply rendering a string, like the example above), but also very complex (for example, they could provide a complete blog engine, or admin backend.)

So here's some of the things a Happy controller can do:

* serve a simple string-like response
* render a template
* process URL paths
* pass control over the request to another controller (or Rack app)

*Note for friends of Rack:* Happy is a very Rack-friendly framework. Happy controllers are also just Rack apps, so you can mount them anywhere that you can mount Rack apps (like inside another Rails application). Happy also happily mounts non-Happy Rack apps, so it works both ways. Life is good.


### The `route` method

Pretty much the most important part of any Happy controller is the `route` method. In your own controller classes, you're expected to override this method to implement your controller's request handling logic.

And this is where Happy is very different from most other web frameworks: instead of dispatching incoming requests among a set of controller classes or actions, Happy will route each and every request -- no exceptions -- through your application controller's `route` method. It is then up to this method to decide on how to deal with the request.

Let's take a look at some examples in the following chapters.


### Handling paths

In most web applications, you will probably want to serve different responses depending on the URL accessed. In Happy, you use the `on` method to define the behavior for specific URL paths. Here's a simple example:

``` ruby
class MyApp < Happy::Controller
  def route
    # When /foo is accessed, respond with 'bar!'
    on 'foo' do
      'bar!'
    end

    # Paths can be nested, of course:
    on 'one' do
      on 'two' do
        'one and two!'
      end

      'just one!'
    end
    
    'Try /foo, /one or /one/two!'
  end
end
```

In other words, `on` lets you provide code blocks that are only executed when a certain path has been requested. Note that `on` calls can be nested; also note that if one of these blocks returns just a string value, it will be rendered as the response.


### Reacting on specific HTTP verbs

While the `on` command doesn't care about the HTTP verb being used to make the request, there's also `on_get`, `on_post`, `on_put` and `on_delete`. Note that these can also be called without a path argument. Here's an example:

``` ruby
class MyApp < Happy::Controller
  def route
    on 'resource' do
      on_get    { 'You accessed /resource using GET!' }
      on_post   { 'You accessed /resource using POST!' }
      on_put    { 'You accessed /resource using PUT!' }
      on_delete { 'You accessed /resource using DELETE!' }
    end
    
    'Try /resource with any HTTP verb!'
  end
end
```

### Setting headers

You can use the `header` method to set any type of HTTP header for your response. Example:

``` ruby
# Set the 'Content-type' header to 'text/css'
header :content_type, 'text/css'
```

There's a couple of shortcut methods available to set certain headers directly. Examples:

```ruby
content_type 'text/css'
cache_control 'public, max-age=3600, must-revalidate'
```

For a complete list, please check the documentation for [`Happy::Controller::Actions`](http://rdoc.info/github/hmans/happy/master/Happy/Controller/Actions).


### Rendering view templates

Obviously, just serving simple strings isn't really what you want in most applications, so Happy also allows you to render view templates through myriad of available template engines. (Happy uses the [tilt](https://github.com/rtomayko/tilt) gem, so any template engine supported by tilt is also supported by Happy.)

All template rendering is done through the `render` method. Simply pass the name of a template file. For example:

``` ruby
class MyApp < Happy::Controller
  def route
    on('info') { render 'info.erb' }
    on('help') { render 'help.erb' }

    render 'home.erb'
  end
end
```

The default directory Happy will look for view templates in is the `views/` subdirectory of your application. This is configurable, of course; more on configuration alter.


### Using layouts

Happy allows you to define a view template as a layout template, applying it to every response generated. Use the `layout` command to set it. For example:

``` ruby
class MyApp < Happy::Controller
  def route
    layout 'layouts/default.erb'

    # From a previous example...
    on('info') { render 'info.erb' }
    on('help') { render 'help.erb' }

    on('admin') do
      # use a different layout inside the admin section
      layout 'layouts/admin.erb'
      render 'admin.erb'
    end

    render 'home.erb'
  end
end
```

The layout file itself should contain an invocation of `yield` where the inner part of the response should appear.


### Adding view helpers

In Happy, view templates are rendered within the scope of your controller (as opposed to a specific view context object), so any method from your controller will also be available in your views.

It is advised, however, that you specifically declare helper methods using the `helper` command so that they are available to _all_ controllers. This is necessary if you modularize your applications into several different controller classes that share view files.

Here's an example:

``` ruby
class MyApp < Happy::Controller
  # You can provide a block that contains method definitions.
  #
  helpers do
    def some_helper
      'something useful'
    end
  end

  # Alternatively, you can provide a module that contains your
  # helper methods
  #
  helpers MyHelpers

  def route
    # home.erb contains calls to helper methods
    render 'home.erb'
  end
end
```


### Serving responses explicitly

You will have noticed by now that if a path block (or the `route` method itself) returns a simple string, it will be used for the response body. However, you can also serve responses explicitly using the `serve!` method. Example:

``` ruby
class MyApp < Happy::Controller
  def route
    serve! 'my response', :content_type => 'text/plain'
  end
end
```

Note that calling `serve!` will finish processing of the current request.

### Passing control over the request to another controller or Rack app
_TODO_


----

## Permission Managament

### Setting and querying permissions
_TODO_

### Permissions for ActiveModel classes
_TODO_


----

## Controller configuration
_TODO_

----

## Happy Recipes

### Writing & Reading Session Data
_TODO_

### Setting & Reading Cookies
_TODO_

### Using HAML in Happy
_TODO_

### Caching
_TODO_

### Using `ResourceController`
_TODO_

### Using `ActiveModelResourceController`
_TODO_

### Authenticating against Twitter, Facebook etc. using OmniAuth
_TODO_

### Handling image uploads using DragonFly
_TODO_
