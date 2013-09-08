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
        Minidown.parse(str).to_html.should == "<ul><li><p>A list item with a blockquote:</p>\n<blockquote><p>This is a blockquote</p><p>inside a list item.</p></blockquote></li></ul>"
      end

      it 'can not work with block without indent' do
        str =<<HERE
*   A list item with a blockquote:

> This is a blockquote
    > inside a list item.
HERE
        Minidown.parse(str).to_html.should == "<ul><li>A list item with a blockquote:</li></ul><br><blockquote><p>This is a blockquote</p><p>inside a list item.</p></blockquote>"
      end

      it 'newline' do
        str =<<HERE
*   A list

Newline
HERE
        Minidown.parse(str).to_html.should == "<ul><li>A list</li></ul><br><p>Newline</p>"
      end

      it 'should parse correct' do
        str = '*   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
    viverra nec, fringilla in, laoreet vitae, risus.
*   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.
    Suspendisse id sem consectetuer libero luctus adipiscing.
---
Hi.'
        Minidown.parse(str).to_html.should == "<ul><li><p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>\n<p>Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,</p>\n<p>viverra nec, fringilla in, laoreet vitae, risus.</p></li><li><p>Donec sit amet nisl. Aliquam semper ipsum sit amet velit.</p>\n<p>Suspendisse id sem consectetuer libero luctus adipiscing.</p></li></ul><hr><p>Hi.</p>"
      end

      it 'list with indent' do
        str ='* first
start with
      #and indent'
        Minidown.parse(str).to_html.should == "<ul><li>first\nstart with</li></ul><h1>and indent</h1>"
      end
    end

    describe 'ol' do
      before :each do
        @random_nums = 5.times.map{rand 42..4242}
      end
      
      it 'should basic parse correct' do
        5.times.map{(42..4242).to_a.sample 3}.each do |n, n2, n3|
          str = "#{n}. ol"
          Minidown.parse(str).to_html.should == '<ol><li>ol</li></ol>'
          str = "#{n}. li1\n#{n2}. li2\n#{n3}.        li3"
          Minidown.parse(str).to_html.should == '<ol><li>li1</li><li>li2</li><li>li3</li></ol>'
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
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
          str = "#{s}.\\ li"
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
          str = "#{s}\\. li"
          Minidown.parse(str).to_html.should == "<p>#{s}. li</p>"
        end
      end

      it 'auto new line' do
        str = '1. li1
    newline
2. li2
newline'
        Minidown.parse(str).to_html.should == "<ol><li><p>li1</p>\n<p>newline</p></li><li>li2\nnewline</li></ol>"
      end

      it '<p> in li' do
        str = '1. li1
    newline

2. li2
newline'
        Minidown.parse(str).to_html.should == '<ol><li><p>li1<br>newline</p></li><li><p>li2<br>newline</p></li></ol>'
      end

      it 'shoud not parse' do
        str = 'line
1. li2'
        Minidown.parse(str).to_html.should == "<p>line<br>1. li2</p>"
      end
      
      it 'two line' do
        str = '1. li1
    newline


2. li2
newline'
        Minidown.parse(str).to_html.should == '<ol><li><p>li1<br>newline</p></li><li><p>li2<br>newline</p></li></ol>'
      end

      it 'can work with indent' do
        str =<<HERE
1.  here a line
noindent
HERE
        Minidown.parse(str).to_html.should == "<ol><li>here a line\nnoindent</li></ol>"

        str =<<HERE
1.  here a line
 noindent
HERE
        Minidown.parse(str).to_html.should == "<ol><li>here a line\n noindent</li></ol>"
      end

      it 'can work with block' do
        str =<<HERE
1.   A list item with a blockquote:

    > This is a blockquote
    > inside a list item.
HERE
        Minidown.parse(str).to_html.should == "<ol><li><p>A list item with a blockquote:</p>\n<blockquote><p>This is a blockquote</p><p>inside a list item.</p></blockquote></li></ol>"
      end

      it 'can not work with block without indent' do
        str =<<HERE
1.   A list item with a blockquote:

> This is a blockquote
    > inside a list item.
HERE
        Minidown.parse(str).to_html.should == "<ol><li>A list item with a blockquote:</li></ol><br><blockquote><p>This is a blockquote</p><p>inside a list item.</p></blockquote>"
      end

      it 'newline' do
        str =<<HERE
1.   A list

Newline
HERE
        Minidown.parse(str).to_html.should == "<ol><li>A list</li></ol><br><p>Newline</p>"
      end

      it 'should parse correct' do
        str = '1.   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
    viverra nec, fringilla in, laoreet vitae, risus.
2.   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.
    Suspendisse id sem consectetuer libero luctus adipiscing.
---
Hi.'
        Minidown.parse(str).to_html.should == "<ol><li><p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>\n<p>Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,</p>\n<p>viverra nec, fringilla in, laoreet vitae, risus.</p></li><li><p>Donec sit amet nisl. Aliquam semper ipsum sit amet velit.</p>\n<p>Suspendisse id sem consectetuer libero luctus adipiscing.</p></li></ol><hr><p>Hi.</p>"
      end

      it 'list with indent' do
        str ='1. first
start with
      #and indent'
        Minidown.parse(str).to_html.should == "<ol><li>first\nstart with</li></ol><h1>and indent</h1>"
      end
    end

    describe 'other case' do
      it 'should parse nest ul' do
        str = '+ ul 1
+ ul 2
   + ul 3
   + ul 4
        + ul 5
   + ul 6'
        Minidown.parse(str).to_html.should == '<ul><li>ul 1</li><li>ul 2
<ul><li>ul 3</li><li>ul 4
<ul><li>ul 5</li></ul></li><li>ul 6</li></ul></li></ul>'
      end

      it 'should parse nest ol' do
        str = '1. ol 1
2. ol 2
   1. ol 3
   123. ol 4
        2. ol 5
   3. ol 6'
        Minidown.parse(str).to_html.should == '<ol><li>ol 1</li><li>ol 2
<ol><li>ol 3</li><li>ol 4
<ol><li>ol 5</li></ol></li><li>ol 6</li></ol></li></ol>'
      end

      it 'should parse correct' do
        str = '+ ul 1
+ ul 2
   + ul 3
   + ul 4
        + ul 5
   + ul 6

1. ul a
1. ul b
1. ul c
1. ul d'
        Minidown.parse(str).to_html.should == '<ul><li>ul 1</li><li>ul 2
<ul><li>ul 3</li><li>ul 4
<ul><li>ul 5</li></ul></li><li>ul 6</li></ul></li></ul><br><ol><li>ul a</li><li>ul b</li><li>ul c</li><li>ul d</li></ol>'
      end

      it 'mixed list should parsed correct' do
        str = '* ul1
 1. ol
 2. ol
 3. ol

* ul2
* ul3
 1.  ol
 2.  ol
 3.  ol
 4.  ol
 5.  ol

+ ul4
+ ul5
 1. ol
 2. ol
 3. ol'
        Minidown.parse(str).to_html.should == '<ul><li><p>ul1</p><ol><li>ol</li><li>ol</li><li>ol</li></ol></li><li><p>ul2</p></li><li><p>ul3</p><ol><li> ol</li><li> ol</li><li> ol</li><li> ol</li><li> ol</li></ol></li><li><p>ul4</p></li><li><p>ul5</p><ol><li>ol</li><li>ol</li><li>ol</li></ol></li></ul>'
      end
    end
  end
end
