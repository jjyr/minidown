module Minidown
  class ParagraphElement < Element
    attr_reader :contents
    
    def initialize *_
      super
      @contents = [raw_content]
    end
    
    def parse
      if ParagraphElement === nodes.last
        nodes.last.contents << raw_content
      else
        nodes << self
      end
    end

    def text
      TextElement.new doc, raw_content
    end

    def to_node document
      node = Nokogiri::XML::Node.new "p", document
      node << TextElement.new(doc, contents.shift).to_node(document)
      contents.each do |line|
        node << Nokogiri::XML::Node.new("br", document)
        node << TextElement.new(doc, line).to_node(document)
      end
      node
    end
  end
end
