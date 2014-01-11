require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe '###### title' do
      it 'should parse "#" as text' do
        Minidown.render('#').should == '<p>#</p>'
      end

      it 'should parse "#####"' do
        (2..7).map{|n| '#' * n}.each do |str|
          tag = "h#{str.size - 1}"
          Minidown.render(str).should == "<#{tag}>#</#{tag}>"
        end
      end

      it 'should ignore blank' do
        str =<<HERE
#### h4 ######
HERE
        Minidown.render(str).should == "<h4>h4</h4>"
      end
    end

    describe 'should not parse escaped' do
      it 'start with escape' do
        %w{\####### \###### \#### \### \## \#}.each do |str|
          Minidown.render(str).should == "<p>#{str[1..-1]}</p>"
        end
      end

      it 'some other case' do
        str = '#\##'
        Minidown.render(str).should == "<h1>\\</h1>"
        str = '##\##\\'
        Minidown.render(str).should == "<h2>##\\</h2>"
        str = '# \# #'
        Minidown.render(str).should == "<h1>#</h1>"
        str = '#\#'
        Minidown.render(str).should == "<h1>\\</h1>"
      end
    end
  end
end
