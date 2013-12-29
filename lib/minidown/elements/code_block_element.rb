module Minidown
  class CodeBlockElement < Element
    
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

    def to_html
      attr = content.empty? ? nil : {class: content}
      build_tag 'pre' do |pre|
        pre << build_tag('code', attr){ |code| code << children.map(&:to_html).join("\n") }
      end
    end
  end
end
