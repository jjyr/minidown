require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'nest syntax' do
      it 'should parse correct' do
        str = "#### [ruby](http://ruby-lang.org/)\n---"
        Minidown.parse(str).to_html.should == "<h4><a href=\"http://ruby-lang.org/\">ruby</a></h4><hr>"
      end
    end
  end
end
