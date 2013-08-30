module Minidown
  class HtmlElement < Element
    attr_reader :name

    def initialize doc, content, name
      super doc, content
      @name = name
    end
    
    def parse
      nodes << self
    end

    def to_html
      build_tag @name do |tag|
        # self.content is some Element
        self.content = content.text if ParagraphElement === self.content
        tag << self.content.to_html
      end
    end
  end
end
