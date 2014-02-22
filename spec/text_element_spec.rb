require 'spec_helper'

describe Minidown do
  describe 'text element' do
    it 'escape' do
      str = "<>"
      Minidown.render(str).should == "<p>&lt;&gt;</p>"
    end

    it 'escape special symbol' do
      str = '\\\\
\\`
\\*
\\_
\\{
\\}
\\[
\\]
\\(
\\)
\\#
\\+
\\-
\\.
\\!'
        Minidown.render(str).should == '<p>\
`
*
_
{
}
[
]
(
)
#
+
-
.
!</p>'.split.join('<br>')
    end

    it 'escape escape symbol' do
      str = %q{\\\\`
\\\\*
\\\\_
\\\\{
\\\\}
\\\\[
\\\\]
\\\\(
\\\\)
\\\\#
\\\\+
\\\\-
\\\\.
\\\\!}
        Minidown.render(str).should == %q{<p>\\`
\\*
\\_
\\{
\\}
\\[
\\]
\\(
\\)
\\#
\\+
\\-
\\.
\\!</p>}.split.join('<br>')
    end

    it 'html tag' do
      str = "<a href=\"http://github.com\">github</a>"
      Minidown.render(str).should == "<p>#{str}</p>"
    end

    context 'link' do
      it 'should parse correct' do
        str = %Q{This is [an example](http://example.com/ "Title") inline link.

[This link](http://example.net/) has no title attribute.}
        Minidown.render(str).should == %Q{<p>This is <a href="http://example.com/" title="Title">an example</a> inline link.</p><p><a href="http://example.net/">This link</a> has no title attribute.</p>}

        str = '[link a](https://a.example.com) and [link b](https://b.example.com)'
        Minidown.render(str).should == "<p><a href=\"https://a.example.com\">link a</a> and <a href=\"https://b.example.com\">link b</a></p>"
      end

      it 'should allow related path' do
        str = "See my [About](/about/) page for details."
        Minidown.render(str).should == %Q{<p>See my <a href=\"/about/\">About</a> page for details.</p>}
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
          Minidown.render(s).should == '<p>I get 10 times more traffic from <a href="http://google.com/" title="Google">Google</a> than from<br><a href="http://search.yahoo.com/" title="Yahoo Search">Yahoo</a> or <a href="http://search.msn.com/" title="MSN Search">MSN</a>.</p>'
        end
      end

      it 'can ignore title' do
        str =<<HERE
I get 10 times more traffic from [Google][] than from
[Yahoo][] or [MSN][].

  [google]: http://google.com/        "Google"
  [yahoo]:  http://search.yahoo.com/
  [msn]:    http://search.msn.com/    "MSN Search"
HERE
        Minidown.render(str).should == '<p>I get 10 times more traffic from <a href="http://google.com/" title="Google">Google</a> than from<br><a href="http://search.yahoo.com/">Yahoo</a> or <a href="http://search.msn.com/" title="MSN Search">MSN</a>.</p>'
      end
    end

    context 'auto link' do
      it 'should parse link' do
        str = "https://github.com/jjyr/minidown"
        Minidown.render(str).should == "<p><a href=\"#{str}\">#{str}</a></p>"
      end

      it 'can parse multi link' do
        str = "https://github.com/jjyr/minidown https://github.com"
        Minidown.render(str).should == "<p><a href=\"https://github.com/jjyr/minidown\">https://github.com/jjyr/minidown</a> <a href=\"https://github.com\">https://github.com</a></p>"
      end

      it 'should not parse link in tag' do
        str = "<a href=\"https://github.com/jjyr/minidown\">minidown</a>"
        Minidown.render(str).should == "<p>#{str}</p>"
      end

      it 'should not parse link without scheme' do
        str = "github.com/jjyr/minidown"
        Minidown.render(str).should == "<p>#{str}</p>"
      end

      it 'should parse email address' do
        str = "jjyruby@gmail.com"
        Minidown.render(str).should == "<p><a href=\"mailto:#{str}\">#{str}</a></p>"
      end

      it 'can parse multi email' do
        str = "jjyruby@gmail.com jjyruby@gmail.com"
        Minidown.render(str).should == "<p><a href=\"mailto:jjyruby@gmail.com\">jjyruby@gmail.com</a> <a href=\"mailto:jjyruby@gmail.com\">jjyruby@gmail.com</a></p>"
      end

      it 'should play with normal text' do
        str = "Hi, jjyruby@gmail.com is my email."
        Minidown.render(str).should == "<p>Hi, <a href=\"mailto:jjyruby@gmail.com\">jjyruby@gmail.com</a> is my email.</p>"

        str = "Hi, <jjyruby@gmail.com> is my email."
        Minidown.render(str).should == "<p>Hi, <a href=\"mailto:jjyruby@gmail.com\">jjyruby@gmail.com</a> is my email.</p>"
      end

      it 'should not parse email in tag' do
        str = "<a href=\"mailto:jjyruby@gmail.com\">jjyr</a>"
        Minidown.render(str).should == "<p>#{str}</p>"
      end

      it 'should parse with <>' do
        str = "<https://github.com/jjyr/minidown>"
        Minidown.render(str).should == "<p><a href=\"#{str[1..-2]}\">#{str[1..-2]}</a></p>"
      end

      it 'should not parse with <> if url invalid' do
        str = "<github.com/jjyr/minidown>"
        Minidown.render(str).should == "<p>#{str}</p>"
      end

      it 'should parse email' do
        str = "<jjyruby@gmail.com>"
        Minidown.render(str).should == "<p><a href=\"mailto:jjyruby@gmail.com\">jjyruby@gmail.com</a></p>"
      end
    end

    context '~~del~~' do
      it 'should parse correct' do
        ['del', 'd', 'i am del'].each do |w|
          str = "~~#{w}~~"
          Minidown.render(str).should == "<p><del>#{w}</del></p>"
        end
      end

      it 'should allow mutil in oneline' do
        str = '~~i am del~~ and ~~i am another del~~'
        Minidown.render(str).should == '<p><del>i am del</del> and <del>i am another del</del></p>'

      end

      it 'should not allow space' do
        str = '~~ del ~~'
        Minidown.render(str).should == '<p>~~ del ~~</p>'
      end

      it 'should allow escape' do
        str = "\\~~del~~"
        Minidown.render(str).should == '<p>~~del~~</p>'
      end
    end

    context '*_ em & strong' do
      it 'parse as em' do
        ['*', '_'].each do |c|
          Minidown.render("#{c}em#{c}").should == '<p><em>em</em></p>'
        end
      end

      it 'should work well with text' do
        Minidown.render("a _close_ a window").should == '<p>a <em>close</em> a window</p>'
        Minidown.render("a *close* a window").should == '<p>a <em>close</em> a window</p>'
      end

      it 'can not mass' do
        Minidown.render("*em_").should == '<p>*em_</p>'
      end

      it 'parse as strong' do
        ['**', '__'].each do |c|
          Minidown.render("#{c}strong#{c}").should == '<p><strong>strong</strong></p>'
        end
      end

      it '* can work in string' do
        Minidown.render("this*em*string").should == '<p>this<em>em</em>string</p>'
      end

      it '_ can not work in string' do
        Minidown.render("_here_method").should == '<p>_here_method</p>'
        Minidown.render("_here_method_").should == '<p><em>here_method</em></p>'
      end

      it 'should parse correct' do
        Minidown.render("_ *what*_").should == '<p>_ <em>what</em>_</p>'
      end

      it 'should allow escape' do
        Minidown.render("\\*\\_\\*").should == '<p>*_*</p>'
      end

      it 'should work well' do
        str = "*View the [source of this content](http://github.github.com/github-flavored-markdown/sample_content.html).*"
        Minidown.render(str).should == "<p><em>View the <a href=\"http://github.github.com/github-flavored-markdown/sample_content.html\">source of this content</a>.</em></p>"
      end
    end

    context 'inline code' do
      it 'should parse correct' do
        str = "Use the `printf()` function."
        Minidown.render(str).should == "<p>Use the <code>printf()</code> function.</p>"
      end

      it 'should can use multi `' do
        str = "``There is a literal backtick (`) here.``"
        Minidown.render(str).should == "<p><code>There is a literal backtick (`) here.</code></p>"

        str = 'A single backtick in a code span: `` ` ``

A backtick-delimited string in a code span: `` `foo` ``'
        Minidown.render(str).should == '<p>A single backtick in a code span: <code>`</code></p><p>A backtick-delimited string in a code span: <code>`foo`</code></p>'
      end

      it 'can parse multi inline code' do
        str = "`hello` `world`"
        Minidown.render(str).should == "<p><code>hello</code> <code>world</code></p>"
      end

      it 'should auto escape' do
        str = "Please don't use any `<blink>` tags."
        Minidown.render(str).should == "<p>Please don't use any <code>&lt;blink&gt;</code> tags.</p>"
      end

      it 'should not auto convert' do
        str = "`jjyruby@gmail.com`"
        Minidown.render(str).should == '<p><code>jjyruby@gmail.com</code></p>'
      end
    end

    context 'image syntax' do
      it 'should parse correct' do
        str = '![Alt text](/path/to/img.jpg)'
        Minidown.render(str).should == "<p><img src=\"/path/to/img.jpg\" alt=\"Alt text\"></img></p>"
      end

      it 'should have title' do
        str = "![Alt text](/path/to/img.jpg \"title\")"
        Minidown.render(str).should == "<p><img src=\"/path/to/img.jpg\" alt=\"Alt text\" title=\"title\"></img></p>"
      end

      it 'should allow reference' do
        str =<<HERE
![Image 1][img1]
![Image 2][img2]
![Image 3][img3]

[img1]: url/to/image1  "Image 1"
[img2]: url/to/image2
[img3]: url/to/image3  "Image 3"
HERE
        Minidown.render(str).should == "<p><img src=\"url/to/image1\" alt=\"Image 1\" title=\"Image 1\"></img><br><img src=\"url/to/image2\" alt=\"Image 2\"></img><br><img src=\"url/to/image3\" alt=\"Image 3\" title=\"Image 3\"></img></p>"
      end
    end
  end
end
