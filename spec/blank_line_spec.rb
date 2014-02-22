require 'spec_helper'

describe Minidown do
  describe 'blank line' do
    it 'should parse as nothing' do
      ['', "\n", "\n\n", "\n\n\n\n"].each do |str|
        Minidown.render(str).should == ''
      end
    end

    it 'should be ignore when blank is the first line' do
      str = "\na"
      Minidown.render(str).should == "<p>a</p>"
      str = "\n\n h"
      Minidown.render(str).should == "<p> h</p>"
      ["\n \n", "\n \n\n\n"].each do |str|
        Minidown.render(str).should == "#{str.split(Minidown::Utils::Regexp[:lines]).last}".strip
      end
    end
  end
end
