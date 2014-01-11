require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'blank line' do
      it 'should parse as nothing' do
        ['', "\n", "\n\n", "\n\n\n\n"].each do |str|
          Minidown.render(str).should == ''
        end
      end

      it 'should parse <br>' do
        str = "\na"
        Minidown.render(str).should == "<br><p>a</p>"
        str = "\n\n h"
        Minidown.render(str).should == "<br><p> h</p>"
        ["\n \n", "\n \n\n\n"].each do |str|
          Minidown.render(str).should == "<br>#{str.split(Minidown::Utils::Regexp[:lines]).last}".strip
        end
      end
    end
  end
end
