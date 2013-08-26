module Minidown
  class ListElement < Element
    attr_accessor :p_tag_content

    def initialize *_
      super
      @p_tag_content = false
    end

    def to_html
      build_tag 'li' do |content|
      content << (@p_tag_content ? ParagraphElement.new(doc, self.content) : TextElement.new(doc, self.content)).to_html
      end
    end
  end
end
