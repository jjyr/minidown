require 'spec_helper'

describe Minidown do
  describe '.parse'do
    describe '======== or -------' do
      it 'should parse as text' do
        %w{===== ------ =====hello ------nihao}.each do |str|
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
        end
      end

      it 'should parse as h1' do
        %w{======= ==== === = ==}.each do |s|
          str =<<HERE
h1
#{s}
HERE
          if s.size < 3
            Minidown.parse(str).to_html.should == "<p>h1<br>#{s}</p>"
          else
            Minidown.parse(str).to_html.should == "<h1>h1</h1>"
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
            Minidown.parse(str).to_html.should == "<p>h2<br>#{s}</p>"
          else
            Minidown.parse(str).to_html.should == "<h2>h2</h2>"
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
          Minidown.parse(str).to_html.should == "<#{tag}>title</#{tag}><p>should show text</p>"
        end
      end
    end
  end
end
