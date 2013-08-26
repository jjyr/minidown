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
          if LineElement === children.last
            @lists.last.p_tag_content = child.lists.first.p_tag_content = true
          end
          children.push *child.children
          @lists.push *child.lists
          break
        when ParagraphElement
          @lists.last.contents << child.text
        when LineElement
          child.display = false
          children << child
        else
          raise "what"
        end
      end
    end
    
    def to_html
      build_tag 'ul' do |content|
        children.each { |child| content << child.to_html}
      end
    end
  end
end
