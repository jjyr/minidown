module Minidown
  class CodeBlockElement < Element

    def initialize *_
      super
      @code_block_handler = doc.options[:code_block_handler]
    end
    
    def parse
      nodes << self
      while(line = unparsed_lines.shift) do
        case line
        when Utils::Regexp[:code_block]
          break
        else
          child = TextElement.new(doc, line)
          child.escape = false
          child.sanitize = true
          child.convert = false
          children << child
        end
      end
    end

    def lang
      @lang ||= content.empty? ? nil : content
    end

    def children_html
      children.map(&:to_html).join("\n")
    end

    def to_html
      return @code_block_handler.call lang, children_html if @code_block_handler
      attr = lang ? {class: lang} : nil
      build_tag 'pre' do |pre|
        pre << build_tag('code', attr){ |code| code << children_html }
      end
    end
  end
end
