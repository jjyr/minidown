module Minidown
  class TextElement < Element
    EscapeChars = %w{#}
    EscapeRegexp = /\\([#{EscapeChars.join '|'}])/
    
    def parse
      if TextElement === nodes.last
        nodes.last.raw_content << raw_content
      else
        nodes << self
      end
    end

    def content
      super.gsub EscapeRegexp, '\\1'
    end

    def to_node doc
      node = Nokogiri::XML::Node.new "p", doc
      node.content = content
      node
    end
  end
end
