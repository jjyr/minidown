require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'ul' do
      it 'should basic parse correct' do
        %w{* + -}.each do |s|
          str = "#{s} ul"
          Minidown.parse(str).to_html.should == '<ul><li>ul</li></ul>'
          str = "#{s} li1\n#{s} li2\n#{s}        li3"
          Minidown.parse(str).to_html.should == '<ul><li>l1</li><li>l2</li><li>l3</li></ul>'
        end
      end

      it 'should not parse' do
        %w{* + -}.each do |s|
          str = "#{s}ul"
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
          str = " #{s} ul"
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
        end
      end

      it 'escape' do
        %w{* + -}.each do |s|
          str = "\\#{s} li"
          Minidown.parse(str).to_html.should == str.gsub("\\", '')
          str = "#{s}\\ li"
          Minidown.parse(str).to_html.should == str
        end
      end

      it 'auto new line' do
        str = '+ li1
    newline
- li2
newline'
        Minidown.parse(str).to_html.should == '<ul><li>li1<br>    newline</li><li>li2<br>newline</li></ul>'
      end

      it '<p> in li' do
        str = '* li1
    newline

* li2
newline'
        Minidown.parse(str).to_html.should == '<ul><li><p>li1<br>    newline</p></li><li><p>li2<br>newline</p></li></ul>'
      end

      it 'shoud not parse' do
        str = 'line
* li2'
        Minidown.parse(str).to_html.should == "<p>#{str}</p>"
      end

      it 'two ul' do
        str = '- li1
    newline


* li2
newline'
        Minidown.parse(str).to_html.should == '<ul><li>li1<br>    newline</li></ul><ul><li>li2<br>newline</li></ul>'
      end
    end

    describe 'ol' do
      before :each do
        @random_nums = 5.times.map{rand 42..4242}
      end
      
      it 'should basic parse correct' do
        5.times.map{(42..4242).sample 3}.each do |n, n2, n3|
          str = "#{n}. ol"
          Minidown.parse(str).to_html.should == '<ol><li>ol</li></ol>'
          str = "#{n} li1\n#{n2} li2\n#{n3}        li3"
          Minidown.parse(str).to_html.should == '<ol><li>l1</li><li>l2</li><li>l3</li></ol>'
        end
      end

      it 'should not parse' do
        @random_nums.each do |s|
          str = "#{s}ol"
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
          str = " #{s} ol"
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
        end
      end

      it 'escape' do
        @random_nums.each do |s|
          str = "\\#{s}. li"
          Minidown.parse(str).to_html.should == str
          str = "#{s}.\\ li"
          Minidown.parse(str).to_html.should == str
          str = "#{s}\\. li"
          Minidown.parse(str).to_html.should == str.gsub("\\", '')
        end
      end

      it 'auto new line' do
        str = '1. li1
    newline
2. li2
newline'
        Minidown.parse(str).to_html.should == '<ol><li>li1<br>    newline</li><li>li2<br>newline</li></ol>'
      end

      it '<p> in li' do
        str = '1. li1
    newline

2. li2
newline'
        Minidown.parse(str).to_html.should == '<ol><li><p>li1<br>    newline</p></li><li><p>li2<br>newline</p></li></ol>'
      end

      it 'shoud not parse' do
        str = 'line
1. li2'
        Minidown.parse(str).to_html.should == "<p>#{str}</p>"
      end
      
      it 'two ol' do
        str = '1. li1
    newline


2. li2
newline'
        Minidown.parse(str).to_html.should == '<ol><li>li1<br>    newline</li></ol><ol><li>li2<br>newline</li></ol>'
      end
    end
  end
end
