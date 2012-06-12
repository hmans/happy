require 'spec_helper'

module Happy
  describe Controller::Configurable do
    class TestController < Happy::Controller
      set :foo, 'bar'
    end

    describe '.set' do
      it 'sets a class-level option' do
        TestController.options[:foo].should == 'bar'
      end
    end

    describe '#set' do
      before do
        @instance = TestController.new
        @instance.set :foo, 'baz'
      end

      it 'sets an instance-level option, overriding the class default' do
        @instance.options[:foo].should == 'baz'
      end

      it "doesn't modify the class-level default option" do
        TestController.options[:foo].should == 'bar'
      end
    end

    describe 'class-level options' do
      it 'are the defaults for instance-level options' do
        TestController.new.options[:foo].should == 'bar'
      end
    end
  end
end
