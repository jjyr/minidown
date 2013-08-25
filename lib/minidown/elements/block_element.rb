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
        when ParagraphElement
          TextElement.new(doc, child.raw_content).parse
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
      new_p_tag = ->(){Nokogiri::XML::Node.new 'p', doc}
      new_br_tag = ->(){Nokogiri::XML::Node.new 'br', doc}
      p_tag = nil
      push_content = ->(content=nil){
        if content.nil?
          return if p_tag.nil? || p_tag.children.empty?
          node << p_tag
          p_tag = nil
        else
          p_tag ? (p_tag << new_br_tag.()) : (p_tag = new_p_tag.())
          p_tag << content
        end
      }
      children.each do |child|
        if TextElement === child
          push_content.(child.raw_content)
        else
          push_content.()
          node << child.to_node(doc)
        end
      end
      push_content.()
      node
    end
  end
end
