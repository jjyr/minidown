require 'spec_helper'

describe Minidown do
  describe '.parse' do
    describe 'text element' do
      context 'link' do
        it 'should parse correct' do
          str = %Q{This is [an example](http://example.com/ "Title") inline link.

[This link](http://example.net/) has no title attribute.}
          Minidown.parse(str).to_html.should == %Q{<p>This is <a href="http://example.com/" title="Title">an example</a> inline link.</p><p><a href="http://example.net/">This link</a> has no title attribute.</p>}
        end

        it 'should allow related path' do
          str = "See my [About](/about/) page for details."
          Minidown.parse(str).to_html.should == %Q{<p>See my <a href=\"/about/\">About</a> page for details.</p>}
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
            Minidown.parse(s).to_html.should == '<p>I get 10 times more traffic from <a href="http://google.com/" title="Google">Google</a> than from<br><a href="http://search.yahoo.com/" title="Yahoo Search">Yahoo</a> or <a href="http://search.msn.com/" title="MSN Search">MSN</a>.</p>'
          end
        end
      end

      context 'auto link' do
        it 'should parse link' do
          str = "https://github.com/jjyr/minidown"
          Minidown.parse(str).to_html.should == "<p><a href=\"#{str}\">#{str}</a></p>"
        end

        it 'should not parse link without scheme' do
          str = "github.com/jjyr/minidown"
          Minidown.parse(str).to_html.should == "<p>#{str}</p>"
        end

        it 'should parse email address' do
          str = "jjyruby@gmail.com"
          Minidown.parse(str).to_html.should == "<p><a href=\"mailto:#{str}\">#{str}</a></p>"
        end

        it 'should parse with <>' do
          str = "<https://github.com/jjyr/minidown>"
          Minidown.parse(str).to_html.should == "<p><a href=\"#{str}\">#{str}</a></p>"
        end

        it 'should not parse with <> if url invalid' do
          str = "<github.com/jjyr/minidown>"
          Minidown.parse(str).to_html.should == "<p></p>"
        end
      end

      context '*_ em & strong' do
        it 'parse as em' do
          ['*', '_'].each do |c|
            Minidown.parse("#{c}em#{c}").to_html.should == '<p><em>em</em></p>'
          end
        end

        it 'can not mass' do
          Minidown.parse("*em_").to_html.should == '<p>*em_</p>'
        end

        it 'parse as strong' do
          ['**', '__'].each do |c|
            Minidown.parse("#{c}strong#{c}").to_html.should == '<p><strong>strong</strong></p>'
          end
        end

        it '* can work in string' do
          Minidown.parse("this*em*string").to_html.should == '<p>this<em>em</em>string</p>'
        end

        it '_ can not work in string' do
          Minidown.parse("_here_method").to_html.should == '<p>_here_method</p>'
          Minidown.parse("_here_method_").to_html.should == '<p><em>here_method</em></p>'
        end

        it 'should parse correct' do
          Minidown.parse("_ *what*_").to_html.should == '<p>_ <em>what</em>_</p>'
        end

        it 'should allow escape' do
          Minidown.parse("\\*\\_\\*").to_html.should == '<p>*_*</p>'
        end
      end
    end
  end
end
