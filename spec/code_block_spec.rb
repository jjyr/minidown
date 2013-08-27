require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'code_block' do
      it 'should parse correct' do
        str =<<HERE
```
should in code block

in block
```
HERE
        Minidown.parse(str).to_html.should == "<pre><code>should in code block\nin block</code></pre>"
      end
      
      it 'should ignore space' do
        str =<<HERE
  ```
should in code block

in block
    ```
HERE
        Minidown.parse(str).to_html.should == "<pre><code>should in code block\nin block</code></pre>"
      end

      it 'should have lang attribute' do
        str =<<HERE
```  ruby
should in code block

in block
```
HERE
        Minidown.parse(str).to_html.should == "<pre lang=\"ruby\"><code>should in code block\nin block</code></pre>"
      end

      it 'should allow escape' do
        str =<<HERE
\```
should in code block

in block
\```
HERE
        Minidown.parse(str).to_html.should == "<p>```<br>should in code block<br>in block<br>```</p>"
      end
    end
  end
end
