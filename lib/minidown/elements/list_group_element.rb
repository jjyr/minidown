module Minidown
  class ListGroupElement < Element
    IndentRegexp = /\A\s{4,}(.+)/
    StartWithBlankRegexp = /\A\s+(.+)/
    
    attr_accessor :lists, :indent_level
    
    def parse
      nodes << self
      while line = unparsed_lines.shift
        #binding.pry
        #handle nested list
        if (line =~ UnorderListElement::NestRegexp && list_class = UnorderListElement) || (line =~ OrderListElement::NestRegexp && list_class = OrderListElement) 
          li, str = $1.size, $2
          if li > @indent_level
            list_class.new(doc, str, li).parse
            @lists.last.contents << nodes.pop
            next
          elsif li == @indent_level
            list_class.new(doc, str, li).parse
            child = nodes.pop
            if LineElement === nodes.last
              @lists.last.p_tag_content = child.lists.first.p_tag_content = true
            end
            if child.is_a?(ListGroupElement)
              nodes.push *child.children
              @lists.push *child.lists
            else
              @lists.last.contents << child
            end
            next
          else
            unparsed_lines.unshift line
            break
          end
        end
                
        # if StartWithBlankRegexp === line
        #   doc.parse_line $1
        #   @lists.last.contents << nodes.pop
        #   next
        # end
        
        doc.parse_line line
        child = nodes.pop
        case child
        when self.class
          if LineElement === nodes.last
            @lists.last.p_tag_content = child.lists.first.p_tag_content = true
          end
          nodes.push *child.children
          @lists.push *child.lists
          break
        when ParagraphElement
          contents = @lists.last.contents
          if line =~ StartWithBlankRegexp
            doc.parse_line $1
            node = nodes.pop
            if TextElement === node || ParagraphElement === node
            if TextElement === contents.last
              contents.push(contents.pop.paragraph)
            end
              node = node.paragraph if TextElement ===  node
            
            end
            
          else
            if @blank
              unparsed_lines.unshift line
              break
            end
            node = child.text
          end
          contents << node if node
        when LineElement
          next_line = unparsed_lines.first
          if next_line.nil? || next_line.empty? || StartWithBlankRegexp === next_line || self.class.const_get(:ListRegexp) === next_line
            child.display = false
            nodes << child
          else
            unparsed_lines.unshift line
            break
          end
        else
          @put_back << child if child
          break
        end
        @blank = (LineElement === child)
      end
      children_range = (nodes.index(self) + 1)..-1
      children.push *nodes[children_range]
      nodes[children_range] = []
      nodes.push *@put_back
    end
  end
end
