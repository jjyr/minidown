require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'blank line' do
      it 'should parse as nothing' do
        ['', "\n", "\n\n", "\n\n\n\n"].each do |str|
          Minidown.parse(str).to_html.should == ''
        end
      end

      it 'should parse <br>' do
        str = "\na"
        Minidown.parse(str).to_html.should == "<br><p>a</p>"
        str = "\n\n h"
        Minidown.parse(str).to_html.should == "<br><p> h</p>"
        ["\n \n", "\n \n\n\n"].each do |str|
          Minidown.parse(str).to_html.should == "<br>#{str.split(Minidown::Utils::Regexp[:lines]).last}".strip
        end
      end
    end
  end
end
