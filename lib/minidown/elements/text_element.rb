module Minidown
  class TextElement < Element
    EscapeChars = %w{# > * + -}
    EscapeRegexp = /\\([#{EscapeChars.join '|'}])/
    
    def parse
      nodes << self
    end

    def content
      super.gsub EscapeRegexp, '\\1'
    end

    def to_html
      content
    end
  end
end
