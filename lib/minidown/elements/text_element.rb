require 'cgi'

module Minidown
  class TextElement < Element
    EscapeChars = %w{# > * + \- `}
    EscapeRegexp = /\\([#{EscapeChars.join '|'}])/
    
    Regexp = {
      link: /\[(.+)\]\((.+)\)/,
      link_title: /((?<=&quot;).+(?=&quot;))/,
      link_url: /(\S+)/,
      link_ref: /\[(.+?)\]\s*\[(.*?)\]/
    }

    attr_accessor :escape, :convert
    
    def initialize *_
      super
      @escape = true
      @convert = true
    end
    
    def parse
      nodes << self
    end

    def content
      str = super
      str.gsub!(EscapeRegexp, '\\1') if escape
      str = CGI.escape_html str
      convert_str(str) if convert
      str
    end

    def convert_str str
      str.gsub! Regexp[:link_ref] do |origin_str|
        text = $1
        id = ($2 && !$2.empty?) ? $2 : $1
        ref = doc.links_ref[id.downcase]
        if ref
          attr = {href: ref[:url]}
          attr[:title] = ref[:title] if ref[:title] && !ref[:title].empty?
          build_tag 'a', attr do |a|
            a << text
          end
        else
          origin_str
        end
      end
      
      str.gsub! Regexp[:link] do
        text, url = $1, $2
        url =~ Regexp[:link_title]
        title = $1
        url =~ Regexp[:link_url]
        url = $1
        attr = {href: url}
        attr[:title] = title if title
        build_tag 'a', attr do |content|
          content << text
        end
      end
    end

    def paragraph
      ParagraphElement.new doc, raw_content
    end

    def to_html
      content
    end
  end
end
