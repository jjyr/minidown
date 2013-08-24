module Minidown
  class TextElement < Element
    def parse
      @doc.nodes << self
    end

    def to_node doc
      Nokogiri::XML::Text.new content, doc
    end
  end
end
