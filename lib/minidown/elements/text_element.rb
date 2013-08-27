require 'cgi'

module Minidown
  class TextElement < Element
    EscapeChars = %w{# > * + \- `}
    EscapeRegexp = /\\([#{EscapeChars.join '|'}])/

    attr_accessor :escape
    
    def initialize *_
      super
      @escape = true
    end
    
    def parse
      nodes << self
    end

    def content
      CGI.escape_html (if escape
                         super.gsub(EscapeRegexp, '\\1')
                       else
                         super
                       end)
    end

    def paragraph
      ParagraphElement.new doc, raw_content
    end

    def to_html
      content
    end
  end
end
