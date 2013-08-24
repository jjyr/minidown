require 'spec_helper'

describe Sumdown do
  describe '.parse' do
    describe '======== or -------' do
      it 'should parse as text' do
        %w{===== ------}.each do |str|
          Sumdown.parse(str).to_html.should == "#{str}<br>"
        end
      end

      it 'should parse as h1' do
        %w{======= ==== === = ==}.each do |s|
          str =<<HERE
h1
#{s}
HERE
          if s.size < 3
            Sumdown.parse(str).to_html.should == "h1\n#{s}\n"
          else
            Sumdown.parse(str).to_html.should == "<h1>h1\n</h1><br>"
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
            Sumdown.parse(str).to_html.should == "h2\n#{s}\n"
          else
            Sumdown.parse(str).to_html.should == "<h2>h2\n</h2><br>"
          end
        end
      end
    end

    describe 'blank line' do
      it 'should parse as <br>' do
        ['', "\n", "\n\n", "\n\n\n\n", "\n\n\n \n\n    \n\n"].each do |str|
          Sumdown.parse(str).to_html.should == (str.size > 0 ? "<br>" : '')
        end
      end
    end
  end
end
