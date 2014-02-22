require 'spec_helper'

describe Minidown do
  describe 'table' do
    it 'should parse correct' do
      str =<<HERE
First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell
HERE
      Minidown.render(str).should == '<table><thead><tr><th>First Header</th><th>Second Header</th></tr></thead><tbody><tr><td>Content Cell</td><td>Content Cell</td></tr><tr><td>Content Cell</td><td>Content Cell</td></tr></tbody></table>'
    end

    it 'should parse correct with pipe end' do
      str =<<HERE
| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
HERE
      Minidown.render(str).should == '<table><thead><tr><th>First Header</th><th>Second Header</th></tr></thead><tbody><tr><td>Content Cell</td><td>Content Cell</td></tr><tr><td>Content Cell</td><td>Content Cell</td></tr></tbody></table>'
    end

    it 'should allow inline markdown' do
    	 str = <<HERE
| Name | Description          |
| ------------- | ----------- |
| Help      | ~~Display the~~ help window.|
| Close     | _Closes_ a window     |
HERE
      Minidown.render(str).should == '<table><thead><tr><th>Name</th><th>Description</th></tr></thead><tbody><tr><td>Help</td><td><del>Display the</del> help window.</td></tr><tr><td>Close</td><td><em>Closes</em> a window</td></tr></tbody></table>'
    end

    it 'should allow define align' do
    	 str = <<HERE
| Left-Aligned  | Center Aligned  | Right Aligned |
| :------------ |:---------------:| -----:|
| col 3 is      | some wordy text | $1600 |
| col 2 is      | centered        |   $12 |
| zebra stripes | are neat        |    $1 |
HERE
	   Minidown.render(str).should == '<table><thead><tr><th align="left">Left-Aligned</th><th align="center">Center Aligned</th><th align="right">Right Aligned</th></tr></thead><tbody><tr><td align="left">col 3 is</td><td align="center">some wordy text</td><td align="right">$1600</td></tr><tr><td align="left">col 2 is</td><td align="center">centered</td><td align="right">$12</td></tr><tr><td align="left">zebra stripes</td><td align="center">are neat</td><td align="right">$1</td></tr></tbody></table>'
    end

    it 'should allow escape' do
      str =<<HERE
\\| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
HERE
      Minidown.render(str).should == '<p>| First Header  | Second Header |<br>| ------------- | ------------- |<br>| Content Cell  | Content Cell  |<br>| Content Cell  | Content Cell  |</p>'
    end

    it 'should not parse as table' do
    	 str = "|not|table|"
    	 Minidown.render(str).should == '<p>|not|table|</p>'
    	 str = "not|table"
    	 Minidown.render(str).should == '<p>not|table</p>'
    end
  end
end
