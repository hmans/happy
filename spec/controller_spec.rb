require 'spec_helper'

module Happy
  describe Controller do
    subject do
      class MyController < Happy::Controller
        def route
          serve! "it works"
        end
      end

      MyController
    end

    it "is mountable as a Rack app" do
      subject.should respond_to(:call)
      get '/'
      last_response.body.should == 'it works'
    end

    describe '#current_url' do
      it "returns the current URL" do
        def app
          build_controller do
            path 'foo' do
              path 'bar' do
                "My URL is #{current_url}"
              end

              "My URL is #{current_url}"
            end

            "My URL is #{current_url}"
          end
        end

        response_for { get '/' }.body.should == 'My URL is /'
        response_for { get '/foo' }.body.should == 'My URL is /foo'
        response_for { get '/foo/bar' }.body.should == 'My URL is /foo/bar'
      end

      it "appends extra paths to the URL if provided" do
        def app
          build_controller do
            path 'foo' do
              current_url('bar', 'moo')
            end
          end
        end

        response_for { get '/foo' }.body.should == "/foo/bar/moo"
      end
    end

    describe '#root_url' do
      it "returns the controller's root URL" do
        def app
          root_url_printer = build_controller do
            path 'bar' do
              "My root URL is still #{root_url}"
            end

            "My root URL is #{root_url}"
          end

          build_controller do
            path 'foo' do
              run root_url_printer
            end

            run root_url_printer
          end
        end

        response_for { get '/' }.body.should == 'My root URL is /'
        response_for { get '/foo' }.body.should == 'My root URL is /foo'
        response_for { get '/foo/bar' }.body.should == 'My root URL is still /foo'
      end

      it "appends extra paths to the root URL if provided" do
        def app
          some_controller = build_controller do
            root_url('bar')
          end

          build_controller do
            path 'foo' do
              run some_controller
            end
          end
        end

        response_for { get '/foo' }.body.should == "/foo/bar"
      end
    end

  end
end
