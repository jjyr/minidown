module Minidown
  class OrderListElement < ListGroupElement
    NestRegexp = /\A(\s*)\d+\.\s+(.+)/
    ListRegexp = Minidown::Utils::Regexp[:order_list]
    
    def initialize doc, line, indent_level = 0
      super doc, line
      @children << ListElement.new(doc, content)
      @lists = @children.dup
      @indent_level = indent_level
      @put_back = []
    end
    
    def to_html
      build_tag 'ol'.freeze do |content|
        children.each { |child| content << child.to_html}
      end
    end
  end
end
