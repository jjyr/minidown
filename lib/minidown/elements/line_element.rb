module Minidown
  class LineElement < Element
    attr_accessor :display
    
    def initialize doc, content=nil
      super
      @display = true
    end

    def blank?
      true
    end
    
    def parse
      node = nodes.last
      @display = (doc.within_block || TextElement === node)
      nodes << self
    end

    def to_html
      if @display
        br_tag
      else
        ''
      end
    end
  end
end
