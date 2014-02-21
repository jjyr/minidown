require 'spec_helper'

describe Minidown do
  describe 'html tag' do
    it 'should render correctly' do
      Minidown.render('<a></a>').should == "<p><a></a></p>"
    end

    it 'can be escaped' do
       Minidown.render("\\<a\\>\\</a\\>\\\\<br\\\\>").should == "<p>&lt;a&gt;&lt;/a&gt;\\<br\\></p>"
    end
  end
end