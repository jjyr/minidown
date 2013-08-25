require 'spec_helper'

describe Minidown do
  describe 'escape parse' do
    context 'should not parse escaped' do
      context '###'do
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
end
