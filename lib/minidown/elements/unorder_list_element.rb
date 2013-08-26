module Minidown
  class UnorderListElement < Element

    attr_accessor :lists
    
    def initialize *_
      super
      @blank = 0
      @children << ListElement.new(doc, content)
      @lists = @children.dup
    end
    
    def parse
      nodes << self
      while @blank < 2 && line = unparsed_lines.shift
        doc.parse_line line
        child = nodes.pop
        @blank = (LineElement === child ? @blank + 1 : 0)
        case child
        when UnorderListElement
          if LineElement === nodes.last
            @lists.last.p_tag_content = child.lists.first.p_tag_content = true
          end
          nodes.push *child.children
          @lists.push *child.lists
          break
        when ParagraphElement
          @lists.last.contents << child.text
        when LineElement
          child.display = false
          nodes << child
        else
          raise "should not execute this line!! *_*"
        end
      end
      children_range = (nodes.index(self) + 1)..-1
      children.push *nodes[children_range]
      nodes[children_range] = []
    end
    
    def to_html
      build_tag 'ul' do |content|
        children.each { |child| content << child.to_html}
      end
    end
  end
end
