module Minidown
  class ParagraphElement < Element
    def parse
      if ParagraphElement === nodes.last
        nodes.last.raw_content << raw_content
      else
        nodes << self
      end
    end

    def to_node document
      TextElement.new(doc, raw_content).to_node document
    end
  end
end
