require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe '###### title' do
      it 'should parse "#" as text' do
        Minidown.parse('#').to_html.should == '<p>#</p>'
      end

      it 'should parse "#####"' do
        (2..7).map{|n| '#' * n}.each do |str|
          tag = "h#{str.size - 1}"
          Minidown.parse(str).to_html.should == "<#{tag}>#</#{tag}>"
        end
      end

      it 'should ignore blank' do
        str =<<HERE
#### h4 ######
HERE
        Minidown.parse(str).to_html.should == "<h4>h4</h4>"
      end
    end

    describe 'should not parse escaped' do
      it 'start with escape' do
        %w{\####### \###### \#### \### \## \#}.each do |str|
          Minidown.parse(str).to_html.should == "<p>#{str[1..-1]}</p>"
        end
      end

      it 'some other case' do
        str = '#\##'
        Minidown.parse(str).to_html.should == "<h1>\\</h1>"
        str = '##\##\\'
        Minidown.parse(str).to_html.should == "<h2>##\\</h2>"
        str = '# \# #'
        Minidown.parse(str).to_html.should == "<h1>#</h1>"
        str = '#\#'
        Minidown.parse(str).to_html.should == "<h1>\\</h1>"
      end
    end
  end
end
