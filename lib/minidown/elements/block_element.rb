module Minidown
  class BlockElement < Element
    BlockTagRegexp = /\A\>\s*/
   
    def parse
      self.content = [content]
      nodes << self
      while(child_line = unparsed_lines.shift) do
        child_line.sub! BlockTagRegexp, ''
        doc.parse_line(child_line)
        child = nodes.pop
        case child
        when LineElement
          unparsed_lines.unshift child_line
          unparsed_lines.unshift nil
        when TextElement
          content << child.raw_content
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
      p_tag = Nokogiri::XML::Node.new 'p', doc
      new_br_tag =->(){Nokogiri::XML::Node.new 'br', doc}
      p_tag << content.shift
      content.each do |line|
        p_tag << new_br_tag.()
        p_tag << line
      end
      node << p_tag
      children.each do |child|
        node << child.to_node(doc)
      end
      node
    end
  end
end
