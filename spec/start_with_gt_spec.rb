require 'spec_helper'

describe Minidown do
  describe 'start with <' do
    it 'should parse as blockquote' do
      [">block", "> block", ">  block", ">     block"].each do |str|
        Minidown.render(str).should == "<blockquote><p>#{str[1..-1].strip}</p></blockquote>"
      end
    end

    it 'should parse correct' do
      str =<<HERE
> here block
> here too
HERE
      Minidown.render(str).should == '<blockquote><p>here block</p><p>here too</p></blockquote>'
    end

    it 'should parse region' do
      str =<<HERE
> here block
here too
    yes
   all is block
bbbbbbbbb

newline
HERE
      Minidown.render(str).should == '<blockquote><p>here block<br>here too<br>    yes<br>   all is block<br>bbbbbbbbb</p></blockquote><br><p>newline</p>'
    end

    it 'should parse nest' do
      str =<<HERE
> here block
 here too
>   yes
   all is block
>>  two level
two too
> still level two
still in block

newline
HERE
      Minidown.render(str).should == '<blockquote><p>here block<br> here too<br>yes<br>   all is block</p><blockquote><p>two level<br>two too<br>still level two<br>still in block</p></blockquote></blockquote><br><p>newline</p>'
    end
  end

  describe 'can use other syntax' do
    it 'use with #' do
      str = '> ## here h2'
      Minidown.render(str).should == '<blockquote><h2>here h2</h2></blockquote>'
    end

    it 'should render mutil <p>' do
      str = '>line1
line2
###h3 ###
another p'
      Minidown.render(str).should == '<blockquote><p>line1<br>line2</p><h3>h3</h3><p>another p</p></blockquote>'
    end
  end

  describe 'should allow escape' do
    it 'should render correct' do
      str = '>\>block'
      Minidown.render(str).should == '<blockquote><p>&gt;block</p></blockquote>'
    end
  end
end
