require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'start with <' do
      it 'should parse as blockquote' do
        [">block", "> block", ">  block", ">     block"].each do |str|
          Minidown.parse(str).to_html.should == "<blockquote><p>#{str[0..-1].strip}</p></blockquote>"
        end
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
        Minidown.parse(str).should == <<HERE
<blockquote><p> here block
here to
    yes
   all is block
bbbbbbbbbbb</p></blockquote>
<br>
<p>newline</p>
HERE
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
        Minidown.parse(str).should == <<HERE
<blockquote><p>here block
here too
yes
all is block</p>
<blockquote><p>two level
two too
still level two
still in block</p></blockquote>
<br>
<p>newline</p>
HERE
      end
    end
  end
end
