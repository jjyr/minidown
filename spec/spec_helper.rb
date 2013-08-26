require 'minidown'
require 'pry'

str = "+ li1\n- li2\n*        li3"
Minidown.parse(str).to_html.should == '<ul><li>l1</li><li>l2</li><li>l3</li></ul>'
exit!
