module Minidown
  class UnorderListElement < Element
    IndentRegexp = /\A\s{4,}(.+)/
    StartWithBlankRegexp = /\A\s+/
    TaskRegexp = /\A\[([ x])\](.+)/
    NestRegexp = /\A(\s+)[*\-+]\s+(.+)/

    attr_accessor :lists, :indent_level
    
    def initialize doc, line, indent_level = 0
      super doc, line
      if content =~ TaskRegexp
        @task_ul ||= true
        list = ListElement.new(doc, $2)
        list.task_list = true
        list.checked = ($1 == 'x')
      else
        list = ListElement.new(doc, content)
      end
      @children << list
      @lists = @children.dup
      @indent_level = indent_level
      @put_back = []
    end
    
    def parse
      nodes << self
      while line = unparsed_lines.shift
        #handle nested ul
        if line =~ NestRegexp
          li, str = $1.size, $2
          if li > @indent_level
            UnorderListElement.new(doc, str, li).parse
            @lists.last.contents << nodes.pop
            next
          elsif li == @indent_level
            UnorderListElement.new(doc, str, li).parse
            child = nodes.pop 
            if LineElement === nodes.last
              @lists.last.p_tag_content = child.lists.first.p_tag_content = true
            end
            nodes.push *child.children
            @lists.push *child.lists
            next
          else
            unparsed_lines.unshift line
            break
          end
        end
        
        doc.parse_line line
        child = nodes.pop        
        case child
        when UnorderListElement
          if LineElement === nodes.last
            @lists.last.p_tag_content = child.lists.first.p_tag_content = true
          end
          nodes.push *child.children
          @lists.push *child.lists
          break
        when ParagraphElement
          contents = @lists.last.contents
          if line =~ IndentRegexp
            doc.parse_line $1
            node = nodes.pop
            contents.push(contents.pop.paragraph) if node && TextElement === contents.last
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
          if next_line.nil? || next_line.empty? || StartWithBlankRegexp === next_line || Utils::Regexp[:unorder_list] === next_line
            child.display = false
            nodes << child
          else
            unparsed_lines.unshift line
            break
          end
        when OrderListElement
          unparsed_lines.unshift line
          break
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
    
    def to_html
      attr = nil
      attr = {class: 'task-list'} if @task_ul
      build_tag 'ul', attr do |content|
        children.each { |child| content << child.to_html}
      end
    end
  end
end
