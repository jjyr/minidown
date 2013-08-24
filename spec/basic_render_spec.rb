require 'spec_helper'

describe Sumdown do
  describe '.parse' do
    describe '======== or -------' do
      it 'should parse as text' do
        %w{===== ------ =====hello ------nihao}.each do |str|
          Sumdown.parse(str).to_html.should == str
        end
      end

      it 'should parse as h1' do
        %w{======= ==== === = ==}.each do |s|
          str =<<HERE
h1
#{s}
HERE
          if s.size < 3
            Sumdown.parse(str).to_html.should == "h1#{s}"
          else
            Sumdown.parse(str).to_html.should == "<h1>h1</h1>"
          end
        end
      end

      it 'should parse as h2' do
        %w{------- ---- --- - --}.each do |s|
          str =<<HERE
h2
#{s}
HERE
          if s.size < 3
            Sumdown.parse(str).to_html.should == "h2#{s}"
          else
            Sumdown.parse(str).to_html.should == "<h2>h2</h2>"
          end
        end
      end

      it 'should parse newtext' do
        %w{------ =======}.each do |s|
          str =<<HERE
title
#{s}should show text
HERE
          tag = (s[0] == '-' ? 'h2' : 'h1')
          Sumdown.parse(str).to_html.should == "<#{tag}>title</#{tag}>should show text"
        end
      end
    end

    describe 'blank line' do
      it 'should parse as nothing' do
        ['', "\n", "\n\n", "\n\n\n\n"].each do |str|
          Sumdown.parse(str).to_html.should == ''
        end
      end

      it 'should parse <br>' do
        ["\na", "\n \n", "\n \n\n\n", "\n\n h"].each do |str|
          Sumdown.parse(str).to_html.should == "<br>#{str.split(Sumdown::Utils::Regexp[:lines]).last}".strip
        end
      end
    end

    describe '###### title' do
      it 'should parse "#" as text' do
        Sumdown.parse('#').to_html.should == '#'
      end

      it 'should parse "#####"' do
        (2..7).map{|n| '#' * n}.each do |str|
          tag = "h#{str.size - 1}"
          Sumdown.parse(str).to_html.should == "<#{tag}>#</#{tag}>"
        end
      end

      it 'should ignore blank' do
        str =<<HERE
#### h4 ######
HERE
        Sumdown.parse(str).to_html.should == "<h4>h4</h4>"
      end
    end
  end
end
