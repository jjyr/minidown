require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'indent should parse as code block' do
      it 'should parse correct' do
        str =<<HERE
Here is a Python code example
without syntax highlighting:

    def foo:
      if not bar:
        return true
HERE
        Minidown.parse(str).to_html.should == "<p>Here is a Python code example<br>without syntax highlighting:</p><pre><code>def foo:\n  if not bar:\n    return true</code></pre>"
      end
    end
  end
end
