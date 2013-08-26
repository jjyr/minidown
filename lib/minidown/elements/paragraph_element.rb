module Minidown
  class ParagraphElement < Element
    attr_reader :contents
    
    def initialize *_
      super
      @contents = [raw_content]
    end
    
    def parse
      if ParagraphElement === nodes.last
        nodes.last.contents << raw_content
      else
        nodes << self
      end
    end

    def text
      TextElement.new doc, raw_content
    end

    def to_html
      build_tag 'p' do |content|
        content << TextElement.new(doc, contents.shift).to_html
        contents.each do |line|
          content << br_tag
          content << TextElement.new(doc, line).to_html
        end
      end
    end
  end
end
