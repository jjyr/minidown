require 'spec_helper'

describe Minidown do
  describe 'raw html spec' do
    it 'should render correctly' do
      Minidown.render('<a></a>').should == "<p><a></a></p>"
    end

    it 'should render mutilple line well' do
      str = '<table>
<tr>
<td>first</td>
</tr>
<tr>
<td>second</td>
</tr>
</table>'
      Minidown.render(str).should == "<p><table><tr><td>first</td></tr><tr><td>second</td></tr></table></p>"
    end

    it 'can be escaped' do
      Minidown.render("\\<a\\>\\</a\\>\\\\<br\\\\>").should == "<p>&lt;a&gt;&lt;/a&gt;\\<br\\></p>"
    end

    it 'should allow mix with markdown' do
      str = 'Table for two
-------------

<table>
  <tr>
    <th>ID</th><th>Name</th><th>Rank</th>
  </tr>
  <tr>
    <td>1</td><td>Tom Preston-Werner</td><td>Awesome</td>
  </tr>
  <tr>
    <td>2</td><td>Albert Einstein</td><td>Nearly as awesome</td>
  </tr>
</table>'
      Minidown.render(str).should == "<h2>Table for two</h2><p><table><tr><th>ID</th><th>Name</th><th>Rank</th></tr><tr><td>1</td><td>Tom Preston-Werner</td><td>Awesome</td></tr><tr><td>2</td><td>Albert Einstein</td><td>Nearly as awesome</td></tr></table></p>"
    end
  end
end
