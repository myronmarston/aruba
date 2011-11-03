require 'spec_helper'

describe Aruba::Api  do

  before(:each) do
    klass = Class.new {
      include Aruba::Api

      def set_tag(tag_name, value)
        self.instance_variable_set "@#{tag_name.to_s}", value
      end
    }
    @aruba = klass.new
  end

  describe 'current_dir' do
    it "should return the current dir as 'tmp/aruba'" do
      @aruba.current_dir.should match(/^tmp\/aruba$/)
    end
  end

  describe 'run' do

    context 'with the @announce_stdout tag' do
      it "should announce to stdout exactly once" do
        @aruba.should_receive(:announce_or_puts).once
        @aruba.set_tag(:announce_stdout, true)
        @aruba.run("ruby -e 'puts \"hello world\"'")
        @aruba.all_output.should match(/hello world/)
      end
    end

    context 'without @announce_stdout tag' do
      it "should not announce to stdout" do
        @aruba.should_not_receive(:announce_or_puts)
        @aruba.set_tag(:announce_stdout, false)
        @aruba.run("ruby -e 'puts \"hello world\"'")
        @aruba.all_output.should match(/hello world/)
      end
    end

  end
end
