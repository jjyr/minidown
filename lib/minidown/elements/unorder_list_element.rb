module Minidown
  class UnorderListElement < ListGroupElement
    TaskRegexp = /\A\[([ x])\](.+)/
    NestRegexp = /\A(\s+)[*\-+]\s+(.+)/
    ListRegexp = Minidown::Utils::Regexp[:unorder_list]

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
    
    def to_html
      attr = nil
      attr = {class: 'task-list'} if @task_ul
      build_tag 'ul', attr do |content|
        children.each { |child| content << child.to_html}
      end
    end
  end
end
