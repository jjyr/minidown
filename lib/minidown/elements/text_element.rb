module Minidown
  class TextElement < Element
    def parse
      nodes << self
    end

    def to_node doc
      Nokogiri::XML::Text.new content, doc
    end
  end
end
