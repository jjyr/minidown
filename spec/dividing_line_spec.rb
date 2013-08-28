require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'dividing line' do
      it 'parsed correct' do
        str = '***'
        Minidown.parse(str).to_html.should == '<hr>'
        str = '---'
        Minidown.parse(str).to_html.should == '<hr>'
        str = ' *** '
        Minidown.parse(str).to_html.should == '<hr>'
        str = ' * * * '
        Minidown.parse(str).to_html.should == '<hr>'
        str = ' -- - '
        Minidown.parse(str).to_html.should == '<hr>'
        str = '----'
        Minidown.parse(str).to_html.should == '<hr>'
      end

      it 'should not parse if any other character' do
        str = 'f---'
        Minidown.parse(str).to_html.should == '<p>f---</p>'

        str = '* * *z'
        Minidown.parse(str).to_html.should == '<p>* * *z</p>'
      end

      it 'should allow escape' do
        str = "\\----"
        Minidown.parse(str).to_html.should == '<p>----</p>'
        str = "\* * *"
        Minidown.parse(str).to_html.should == '<p>* * *</p>'
      end
    end
  end
end
