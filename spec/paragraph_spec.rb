require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'paragraph' do
      it 'should correct' do
        str = 'line1
line2

new paragraph
    some space
same paragraph

new p'
        Minidown.parse(str).to_html.should == '<p>line1<br>line2</p><p>new paragraph<br>    some space<br>same paragraph</p><p>new p</p>'
      end
    end
  end
end
