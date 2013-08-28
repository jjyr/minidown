require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'text element' do
      context 'link' do
        it 'should parse correct' do
          str = %Q{This is [an example](http://example.com/ "Title") inline link.

[This link](http://example.net/) has no title attribute.}
          Minidown.parse(str).to_html.should == %Q{<p>This is <a href="http://example.com/" title="Title">
an example</a> inline link.</p>

<p><a href="http://example.net/">This link</a> has no
title attribute.</p>}
        end

        it 'should allow related path' do
          str = "See my [About](/about/) page for details."
          Minidown.parse(str).to_html.should == %Q{<p>See my <a href=\"/about/\">About<a/> page for details.</p>}
        end

        it 'should allow reference' do
          str =<<HERE
I get 10 times more traffic from [Google] [1] than from
[Yahoo] [2] or [MSN] [3].

  [1]: http://google.com/        "Google"
  [2]: http://search.yahoo.com/  "Yahoo Search"
  [3]: http://search.msn.com/    "MSN Search"
HERE
          str2 =<<HERE
I get 10 times more traffic from [Google][] than from
[Yahoo][] or [MSN][].

  [google]: http://google.com/        "Google"
  [yahoo]:  http://search.yahoo.com/  "Yahoo Search"
  [msn]:    http://search.msn.com/    "MSN Search"
HERE
          [str, str2].each do |s|
            Minidown.parse(s).to_html.should == '<p>I get 10 times more traffic from <a href="http://google.com/"
title="Google">Google</a> than from
<a href="http://search.yahoo.com/" title="Yahoo Search">Yahoo</a>
or <a href="http://search.msn.com/" title="MSN Search">MSN</a>.</p>'
          end
        end
      end
    end
  end
end
