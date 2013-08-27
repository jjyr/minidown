require 'cgi'

module Minidown
  class TextElement < Element
    EscapeChars = %w{# > * + -}
    EscapeRegexp = /\\([#{EscapeChars.join '|'}])/
    
    def parse
      nodes << self
    end

    def content
      CGI.escape_html super.gsub(EscapeRegexp, '\\1')
    end

    def paragraph
      ParagraphElement.new doc, raw_content
    end

    def to_html
      content
    end
  end
end
