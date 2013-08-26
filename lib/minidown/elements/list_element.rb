module Minidown
  class ListElement < Element
    attr_accessor :p_tag_content, :contents

    def initialize *_
      super
      @p_tag_content = false
      @contents = [TextElement.new(doc, content)]
    end

    def to_html
      content = @contents.map(&:to_html).join br_tag
      content = build_tag('p'){|p| p << content} if @p_tag_content
      build_tag 'li' do |li|
        li << content
      end
    end
  end
end
