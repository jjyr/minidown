module Minidown
  class ListElement < Element
    attr_accessor :p_tag_content, :contents, :task_list, :checked
    CheckedBox = '<input type="checkbox" class="task-list-item-checkbox" checked="" disabled="">'
    UnCheckedBox = '<input type="checkbox" class="task-list-item-checkbox" disabled="">'

    def initialize *_
      super
      @p_tag_content = false
      @contents = [TextElement.new(doc, content)]
      @task_list = false
      @checked = false
    end

    def to_html
      @contents.map! do |content|
        ParagraphElement === content ? content.text : content
      end if @p_tag_content
      content = list_content
      content = build_tag('p'){|p| p << content} if @p_tag_content
      attr = nil
      attr = {class: 'task-list-item'} if @task_list
      build_tag 'li', attr do |li|
        li << content
      end
    end

    def list_content
      content = @contents.map(&:to_html).join(@p_tag_content ? br_tag : "\n")
      if @task_list
        content = (@checked ? CheckedBox : UnCheckedBox) + content
      end
      content
    end
  end
end
