# -*- encoding: utf-8 -*-
require 'spec_helper'

module Happy
  module Helpers
    describe Html do
      include Html

      describe "#url_for" do
        it "generates a url from an array of strings" do
          url_for('foo', 'bar', '123').should == '/foo/bar/123'
        end

        it "removes duplicate dashes" do
          url_for('/foo/', 'bar').should == '/foo/bar'
        end

        it "removes leading dashes" do
          url_for('foo/').should == '/foo'
        end

        it "returns just a slash if no parameters are given" do
          url_for().should == '/'
        end

        it "doesn't take nil into account" do
          url_for('foo', nil, 'bar').should == '/foo/bar'
        end

        it "also accepts symbols" do
          url_for(:foo, 'bar').should == '/foo/bar'
        end

        it "generates RESTful URLs from objects" do
          url_for(mock(:class => 'thingy', :to_param => '1')).should == '/thingies/1'
        end

        it "is can be cascaded" do
          url_for(url_for(:foo, :bar), '123', url_for('woop')).should == '/foo/bar/123/woop'
        end

        it "doesn't modify strings containing complete URLs" do
          url_for('http://www.test.com').should == 'http://www.test.com'
        end
      end
    end
  end
end
