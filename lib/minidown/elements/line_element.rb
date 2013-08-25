module Minidown
  class LineElement < Element
    def initialize doc, content=nil
      super
      @display = true
    end
    
    def parse
      node = nodes.last
      @display = !(LineElement === node || ParagraphElement === node)
      nodes << self
    end

    def to_node doc
      if @display
        Nokogiri::XML::Node.new 'br', doc
      else
        ''
      end
    end
  end
end
