module Minidown
  class BlockElement < Element
    BlockTagRegexp = /\A\>\s*/
   
    def parse
      unparsed_lines.unshift content
      nodes << self
      while(child_line = unparsed_lines.shift) do
        child_line.sub! BlockTagRegexp, ''
        doc.parse_line(child_line)
        child = nodes.pop
        case child
        when LineElement
          unparsed_lines.unshift child_line
          unparsed_lines.unshift nil
        else
          nodes << child
        end
      end
      children_range = (nodes.index(self) + 1)..-1
      self.children = nodes[children_range]
      nodes[children_range] = []
    end

    def to_node doc
      node = Nokogiri::XML::Node.new 'blockquote', doc
      children.each do |child|
        node << child.to_node(doc)
      end
      node
    end
  end
end
