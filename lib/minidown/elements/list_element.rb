module Minidown
  class ListElement < Element
    attr_accessor :p_tag_content, :contents

    def initialize *_
      super
      @p_tag_content = false
      @contents = [TextElement.new(doc, content)]
    end

    def to_html
      @contents.map! do |content|
        ParagraphElement === content ? content.text : content
      end if @p_tag_content
      content = @contents.map(&:to_html).join(@p_tag_content ? br_tag : "\n")
      content = build_tag('p'){|p| p << content} if @p_tag_content
      build_tag 'li' do |li|
        li << content
      end
    end
  end
end
