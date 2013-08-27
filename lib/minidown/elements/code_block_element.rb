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
          children << child
        end
      end
    end

    def to_html
      attr = content.empty? ? nil : {lang: content}
      build_tag 'pre', attr do |pre|
        pre << build_tag('code'){ |code| code << children.map(&:to_html).join("\n") }
      end
    end
  end
end
