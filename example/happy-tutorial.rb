# The most important class Happy provides is [Happy::Controller](http://rdoc.info/github/hmans/happy/master/Happy/Controller).
# Pretty much everything you develop with Happy will be some class derived from it.
# Happy Controllers are discrete applications that can be mounted as Rack
# apps or invoked from within other Happy Controllers, but more on that
# later.
#
# Every controller defines a `#route` instance method that is called for
# every request hitting your application. You can do all sorts of stuff
# inside that method (first and foremost, it allows you to deal with specific
# URLs being requested), but more on that later. For now, we'll simply return
# a string -- which will be returned as the response to the browser.

class HelloWorld < Happy::Controller
  def route
    "Hello, world!"
  end
end


# ### Handling URLs
#
# Obviously, your app should be able to do a lot more than just display
# a string of text at its root URL. Fret not, for Happy gives you powerful
# tools to create pretty much any URL structure you can think of; however,
# the way it works is **significantly different** from what you may be used
# from other MVC frameworks like Rails or Padrino.
#
# To sum things up, the main difference in Happy is that each and every request
# that hits your application will go through the root controller's `#route`
# method, leaving it up to that method what happens next.
#
# In practice this means that instead of mapping routes to specific controllers
# or actions, in Happy requests pass through a linear flow of logic that
# makes decisions about how to handle the request on the fly.
#
# Happy provides the `#on` method that allows you to provide code that
# is only executed if a matching URL is requested. These can be nested,
# too; for example, this block of code will handle the `/foo` and `/foo/bar`
# URLs.
#
class MyApp < Happy::Controller
  def route
    on 'foo' do
      on 'bar' do
        "You requested /foo/bar!"
      end

      "You requested /foo!"
    end

    "You requested /!"
  end
end
