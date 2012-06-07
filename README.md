# Happy Ruby

**The Happy Web Application Toolkit for Ruby.**

## Introduction

Happy is a toolkit for developing web applications using Ruby. Inspired by both Sinatra and Rails, it sits somewhere in the middle, trying to offer the super-light-weight attitude and flexibility of Sinatra, the comfort and power of Rails, and adding a big chunk of extensibility and modularity that any lover of object-oriented application design will enjoy.

Furthermore, the way Happy handles incoming requests is vastly different from how most of the other frameworks do it, offering a new, extremely flexible and, yes, fun way of building your application.

### Examples

"Hello world" with Happy:

```ruby
# config.ru
require 'happy'

Happy.route do
  'Hello world'
end

run Happy
```

How about something a little bit closer to reality?

``` ruby
# config.ru
require 'happy'

Happy.route do
  # Set a default layout for all responses!
  layout 'application.erb'

  # Happily deal with sub-paths!
  path 'hello' do
    # Let's use a different layout here.
    layout 'hello_layout.erb'

    # Happily deal with parameters contained in paths!
    path :name do
      # Just return a string to happily render it!
      "Hello, #{params['name']}"!
    end

    "Silly user, didn't provide a name!"
  end

  # Now let's do something a little bit more exciting!
  #
  # How about passing control to another controller? In this instance,
  # we're invoking an instance of ResourceMounter, a controller class
  # that serves a model resource RESTful-Rails-style. We'll save a 
  # reference to the controller for later.

  articles = ResourceMounter.new(:class => Article)
  articles.perform

  # Or use the shortcut: invoke :resource_mounter, :class => Article

  # This block of code is executed for every request, so you can do
  # some crazy stuff here, including only defining specific paths
  # when certain conditions are given. Just write Ruby! :)
  
  if context.user_is_admin?
    path 'delete_everything' do
      Article.delete_all

      # How about rendering a view template and passing
      # variables to it?
      render 'admin_message.erb',
        :message => 'You just deleted everything. Grats!'
    end
  end

  # If we reach this point, the request still hasn't been handled, so
  # the user must by trying to access the root URL. How about a redirect
  # to the URL of the previously invoked controller?
  
  redirect! articles.root_url
end

run Happy
```


### The Basic Building Blocks

Each and every web application built with Happy revolves around two core building blocks: the **context** and one or more **controllers**.

The **context** is a wrapper around the request currently being handled by your application. It holds information about the request itself, the response being rendered, and any piece of application logic that's scoped to individual requests (like authentication or authorization related code.) Happy doesn't have view helpers (like Rails); instead, view templates are rendered within the scope of the current context.

**Controllers** are building blocks that mostly deal with routing and acting on request URLs. Unlike controllers in Rails, instead of deciding on what controller to run depending on the requested URL, each request is immediately passed to a **root controller** which then decides how to continue. Controllers can serve content, parse the URL for paths, or even pass on control over the request to a different controller.

Controllers are the magic behind Happy; they're essentially **re-useable, self-contained, easily testable** web application classes that can be mounted at any URL you require. They can be as simple as serving a single response or as complex as a complete admin backend or blog engine. And finally, Happy Controllers are also **Rack applications**, so you can even use them anywhere you can mount Rack apps!


### More Happy Features

In addition to its fun and flexible approach to writing web applications, Happy boasts the following features, and more:

* Run-time permission management provided by [Allowance](https://github.com/hmans/allowance).
* A set of Happy Controllers making you super-productive, from serving static files to minifying JavaScript assets or even serving complete RESTful resources.
* A set of view helpers including [simple_form](https://github.com/plataformatec/simple_form) inspired forms on auto-pilot, with full support for translations and localization through [I18n](https://github.com/svenfuchs/i18n).
* Happy _loves_ Rack. You can mount Rack Middleware as well as pass control to another Rack application, just like that. Or use Happy Controllers from within other applications -- they're just Rack apps. And, of course, serve your Happy application through any Rack-compliant Rack server.


### Happy is Opinionated Software

Happy is opinionated software. Its design and functionality follow a certain set of opinions, a few of which are:

* **The core framework should be very simple**. As described above, the entire framework revolves around two important classes (Happy::Controller and Happy::Context). Everything that's not directly related to the core framework should be provided by additional gems. (For example, anything that is view helper related has been moved to the [HappyHelpers](https://github.com/hmans/happy-helpers) gem, and the permission management code has been extracted to the [Allowance](https://github.com/hmans/allowance) gem.) Happy isn't trying to be a kitchen sink framework.
* **Full-stack is boring**. Sure, it's nice if your framework of choice is holding your hands almost every step you go, but it's when you get to that point where you want to do something _differently_ from what your framework provides to you that you'll start hitting walls. For example, Happy doesn't generate data layer code for you; you're expected (and free to) simply use any ORM (or whatever) you desire, if any. For example, adding [Mongoid](http://mongoid.org/) to your Happy project is just two lines of code. Don't worry, we'll provide recipes; you don't need generators for that kind of stuff.
* **Routing sucks**. Pretty much all other Ruby web application frameworks go to great lengths to map incoming requests to code through regular expressions (or DSLs allowing you to specify routes that are then compiled to regular expressions behind the scenes.) It's a very fast, but somewhat inflexible approach.
* **Objects are awesome**. Frameworks like Rails are, technically speaking, object-oriented, but really only use classes mostly as containers for code. Requests are mapped (through the aforementioned routes) to controller classes, which are then instantiated and passed control to. It works, but it's also really boring. Objects are fun! Happy uses the request URL as a roadmap through your application's object graph. It allows you to think of your application as a nested tree of _things_.

If you find that you agree with these, you're going to _love_ building Happy web applications.


## Current Status

Happy is being extracted from a web application that I've been working on. I'm trying to get a first, hopefully somewhat stable release out of the door some time during June 2012.

FWIW, here's a list of important things still missing right now:

* Nicer error pages for 404s, 401s etc.
* Better logging.
* Improved view engine compatibility.

Hendrik Mans, hendrik@mans.de
