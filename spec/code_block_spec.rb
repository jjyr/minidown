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
        Minidown.parse(str).to_html.should == "<pre><code>should in code block\n\nin block</code></pre>"
      end
      
      it 'should allow tildes as well as backquotes' do
        str =<<HERE
~~~
should in code block

in block
~~~
HERE
        Minidown.parse(str).to_html.should == "<pre><code>should in code block\n\nin block</code></pre>"
      end

      it 'should allow arbitrary number of `' do
        str =<<HERE
````````````
should in code block

in block
````````````
HERE
        Minidown.parse(str).to_html.should == "<pre><code>should in code block\n\nin block</code></pre>"
      end

      it 'should allow arbitrary number of tildes' do
        str =<<HERE
~~~~~~~~~~~
should in code block

in block
~~~~~~~~~~~
HERE
        Minidown.parse(str).to_html.should == "<pre><code>should in code block\n\nin block</code></pre>"
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

      it 'should have class attribute' do
        str =<<HERE
```  ruby
should in code block

in block
```
HERE
        Minidown.parse(str).to_html.should == "<pre><code class=\"ruby\">should in code block\n\nin block</code></pre>"
      end

      it 'should have class attribute with tildes' do
        str =<<HERE
~~~  ruby
should in code block

in block
~~~
HERE
        Minidown.parse(str).to_html.should == "<pre><code class=\"ruby\">should in code block\n\nin block</code></pre>"
      end

      it 'should allow escape' do
        str =<<HERE
\\```
should in code block

in block
\\```
HERE
        Minidown.parse(str).to_html.should == "<p>```<br>should in code block</p><p>in block<br>```</p>"
        str =<<HERE
\\~~~
should in code block

in block
\\~~~
HERE
        Minidown.parse(str).to_html.should == "<p>~~~<br>should in code block</p><p>in block<br>~~~</p>"
      end

      it 'should not escape content' do
        str =<<HERE
```
\\+
\\.
\\-
\\*
<>
```
HERE
        Minidown.parse(str).to_html.should == "<pre><code>\\+\n\\.\n\\-\n\\*\n&lt;&gt;</code></pre>"
        str =<<HERE
~~~
\\+
\\.
\\-
\\*
<>
~~~
HERE
        Minidown.parse(str).to_html.should == "<pre><code>\\+\n\\.\n\\-\n\\*\n&lt;&gt;</code></pre>"
      end

      it 'should escape html tag' do
        str ='```
<a>hello</a>
```'
        Minidown.parse(str).to_html.should == "<pre><code>&lt;a&gt;hello&lt;/a&gt;</code></pre>"
        str ='~~~
<a>hello</a>
~~~'
        Minidown.parse(str).to_html.should == "<pre><code>&lt;a&gt;hello&lt;/a&gt;</code></pre>"
      end

      it 'should not auto convert' do
        str = '```
jjyruby@gmail.com
```'
        Minidown.parse(str).to_html.should == '<pre><code>jjyruby@gmail.com</code></pre>'
        str = '~~~
jjyruby@gmail.com
~~~'
        Minidown.parse(str).to_html.should == '<pre><code>jjyruby@gmail.com</code></pre>'
      end
    end
  end
end
