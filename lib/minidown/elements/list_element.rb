module Minidown
  class ListElement < Element
    attr_accessor :p_tag_content

    def initialize *_
      super
      @p_tag_content = false
    end

    def to_node document
      node = Nokogiri::XML::Node.new 'li', document
      node << (@p_tag_content ? ParagraphElement.new(doc, content) : TextElement.new(doc, content)).to_node(document)
      node
    end
  end
end
