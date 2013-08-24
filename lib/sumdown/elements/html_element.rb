module Sumdown
  class HtmlElement < Element
    def initialize doc, content, name
      super doc, content
      @name = name
    end
    
    def parse
      @nodes << self
    end

    def to_node doc
      node = Nokogiri::XML::Node.new name, doc
      node.children = content
      node
    end
  end
end
