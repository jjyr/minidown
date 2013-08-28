module Minidown
  class DividingLineElement < Element
    def parse
      nodes << self
    end

    def to_html
      '<hr>'
    end
  end
end
