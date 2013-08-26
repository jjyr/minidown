module Minidown
  class HtmlElement < Element
    def initialize doc, content, name
      super doc, content
      @name = name
    end
    
    def parse
      nodes << self
    end

    def to_html
      build_tag @name do |content|
        # self.content is TextElement
        content << self.content.content
      end
    end
  end
end
