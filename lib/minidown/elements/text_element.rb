require 'cgi'

module Minidown
  class TextElement < Element
    EscapeChars = %w{# > * + \- `}
    EscapeRegexp = /\\([#{EscapeChars.join '|'}])/

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
      CGI.escape_html str
    end

    def paragraph
      ParagraphElement.new doc, raw_content
    end

    def to_html
      content
    end
  end
end
