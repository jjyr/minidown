module Minidown
  class BlockElement < Element
    BlockTagRegexp = /\A\s*\>\s*/
   
    def parse
      unparsed_lines.unshift content
      nodes << self
      while(child_line = unparsed_lines.shift) do
        block = child_line.sub! BlockTagRegexp, ''
        doc.parse_line(child_line)
        child = nodes.pop
        case child
        when LineElement
          unparsed_lines.unshift child_line
          unparsed_lines.unshift nil
        when ParagraphElement
          child.extra = !!block
          nodes << child
        else
          break if child.nil?
          nodes << child 
        end
      end
      children_range = (nodes.index(self) + 1)..-1
      self.children = nodes[children_range]
      nodes[children_range] = []
    end

    def to_html
      build_tag 'blockquote' do |content|
        children.each do |child|
          content << child.to_html
        end
      end
    end
  end
end
