require 'spec_helper'

describe Minidown do
  describe 'dividing line' do
    it 'parsed correct' do
      str = '***'
      Minidown.render(str).should == '<hr>'
      str = '---'
      Minidown.render(str).should == '<hr>'
      str = ' *** '
      Minidown.render(str).should == '<hr>'
      str = ' * * * '
      Minidown.render(str).should == '<hr>'
      str = ' -- - '
      Minidown.render(str).should == '<hr>'
      str = '----'
      Minidown.render(str).should == '<hr>'
    end

    it 'should not parse if any other character' do
      str = 'f---'
      Minidown.render(str).should == '<p>f---</p>'

      str = '* * *z'
      Minidown.render(str).should == '<ul><li><em> </em>z</li></ul>'
    end

    it 'should allow escape' do
      str = "\\----"
      Minidown.render(str).should == '<p>----</p>'
      str = "\\* * *"
      Minidown.render(str).should == '<p>* <em> </em></p>'
    end
  end
end
