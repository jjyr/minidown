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
          children.push *child.children
          if LineElement === children.last
            @lists.last.p_tag_content = child.lists.first.p_tag_content = true
          end
          @lists.push *child.lists
          break
        when ParagraphElement
          children << LineElement.new(doc)
          children << child.text
        when LineElement
          child.display = false
        else
          raise "what"
        end
      end
    end
    
    def to_html
      build_tag 'ul' do |content|
        children.each do |child|
          content << child.to_html
        end
      end
    end
    
  end
end
