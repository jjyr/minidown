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
  end
end
