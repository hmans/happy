require 'spec_helper'

module Happy
  describe Controller::Configurable do
    class TestController < Happy::Controller
      set :foo, 'bar'
    end

    describe '.set' do
      it 'sets a class-level option' do
        TestController.settings[:foo].should == 'bar'
      end
    end

    describe '#set' do
      before do
        @instance = TestController.new
        @instance.set :foo, 'baz'
      end

      it 'sets an instance-level option, overriding the class default' do
        @instance.settings[:foo].should == 'baz'
      end

      it "doesn't modify the class-level default option" do
        TestController.settings[:foo].should == 'bar'
      end
    end

    describe 'class-level settings' do
      it 'are the defaults for instance-level settings' do
        TestController.new.settings[:foo].should == 'bar'
      end
    end

    describe 'cascading settings' do
      class OuterController < Controller
        set :views, './foo/'
        set :foo, 'bar'
      end

      class InnerController < Controller
      end

      it "are copied from the parent controller if necessary" do
        @instance = InnerController.new(OuterController.new)
        @instance.settings[:views].should == './foo/'
        @instance.settings[:foo].should be_nil
      end
    end

    describe 'settings passed to the initializer' do
      it "override default settings" do
        @instance = TestController.new({}, :foo => 'baz')
        @instance.settings[:foo].should == 'baz'
      end
    end
  end
end
