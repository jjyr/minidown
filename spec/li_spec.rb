require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'ul' do
      it 'should basic parse correct' do
        %w{* + -}.each do |s|
          str = "#{s} ul"
          Minidown.parse(str).to_html.should == '<ul><li>ul</li></ul>'
          str = " #{s} ul"
          Minidown.parse(str).to_html.should == '<ul><li>ul</li></ul>'
          str = "#{s} li1\n#{s} li2\n#{s}        li3"
          Minidown.parse(str).to_html.should == '<ul><li>li1</li><li>li2</li><li>li3</li></ul>'
        end
      end

      it 'should not parse' do
        %w{* + -}.each do |s|
          str = "#{s}ul"
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
        end
      end

      it 'escape' do
        %w{* + -}.each do |s|
          str = "\\#{s} li"
          Minidown.parse(str).to_html.should == "<p>#{str.gsub("\\", '')}</p>"
          str = "#{s}\\ li"
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
        end
      end

      it 'auto new line' do
        str = '+ li1
    newline
- li2
newline'
        Minidown.parse(str).to_html.should == "<ul><li><p>li1</p>\n<p>newline</p></li><li>li2\nnewline</li></ul>"
      end

      it '<p> in li' do
        str = '* li1
    newline

* li2
newline'
        Minidown.parse(str).to_html.should == "<ul><li><p>li1<br>newline</p></li><li><p>li2<br>newline</p></li></ul>"
      end

      it 'shoud not parse' do
        str = 'line
* li2'
        Minidown.parse(str).to_html.should == "<p>line<br>* li2</p>"
      end

      it 'two ul' do
        str = '- li1
    newline


* li2
newline'
        Minidown.parse(str).to_html.should == '<ul><li><p>li1<br>newline</p></li><li><p>li2<br>newline</p></li></ul>'
      end

      it 'can work with indent' do
        str =<<HERE
*  here a line
noindent
HERE
        Minidown.parse(str).to_html.should == "<ul><li>here a line\nnoindent</li></ul>"

        str =<<HERE
*  here a line
 noindent
HERE
        Minidown.parse(str).to_html.should == "<ul><li>here a line\n noindent</li></ul>"
      end

      it 'can work with block' do
        str =<<HERE
*   A list item with a blockquote:

    > This is a blockquote
    > inside a list item.
HERE
        Minidown.parse(str).to_html.should == "<ul><li><p>A list item with a blockquote:</p>\n<blockquote><p>This is a blockquote<br>inside a list item.</p></blockquote></li></ul>"
      end

      it 'can not work with block without indent' do
        str =<<HERE
*   A list item with a blockquote:

> This is a blockquote
    > inside a list item.
HERE
        Minidown.parse(str).to_html.should == "<ul><li>A list item with a blockquote:</li></ul><blockquote><p>This is a blockquote<br>inside a list item.</p></blockquote>"
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

      it 'can work with indent' do
        str =<<HERE
1.  here a line
noindent
HERE
        Minidown.parse(str).to_html.should == "<ul><li>here a line</li><p>noindent</p></ul>"

        str =<<HERE
1.  here a line
 noindent
HERE
        Minidown.parse(str).to_html.should == "<ul><li><p>here a line</p><p>noindent</p></li></ul>"
      end

      it 'can work with block' do
        str =<<HERE
1.   A list item with a blockquote:

    > This is a blockquote
    > inside a list item.
HERE
        Minidown.parse(str).to_html.should == "<ul><li><p>A list item with a blockquote:</p><blockquote><p>This is a blockquote<br>inside a list item.</p></blockquote></li></ul>"
      end

      it 'can not work with block without indent' do
        str =<<HERE
1.   A list item with a blockquote:

> This is a blockquote
    > inside a list item.
HERE
        Minidown.parse(str).to_html.should == "<ul><li>A list item with a blockquote:</li></ul><blockquote><p>This is a blockquote<br>inside a list item.</p></blockquote>"
      end
    end
  end
end
