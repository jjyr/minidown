module Minidown
  class RawHtmlElement < Element
    def parse
      nodes << self
    end

    def to_html
      content
    end
  end
end
