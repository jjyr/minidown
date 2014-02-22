module Minidown
  class ParagraphElement < Element
    attr_reader :contents
    attr_accessor :extra

    ExcludeSchemeRegexp = /\A[^@:]+\z/
    StringSymbolRegexp = /"|'/

    def initialize *_
      super
      @contents = [raw_content]
      @extra = false
    end

    def parse
      if ParagraphElement === nodes.last
        nodes.last.contents << raw_content
      else
        nodes << self
      end
    end

    def text
      build_element raw_content
    end

    def to_html
      if @extra
        contents.map{|content| ParagraphElement.new(doc, content).to_html }.join ''.freeze
      else
        contents.map! do |line|
          build_element line
        end
        build_tag 'p'.freeze do |content|
          pre_elem = contents.shift
          content << pre_elem.to_html
          while elem = contents.shift
            content << br_tag if TextElement === pre_elem && TextElement === elem
            content << elem.to_html
            pre_elem = elem
          end
        end
      end
    end

    private

    def build_element content_str
      if Utils::Regexp[:raw_html] =~ content_str && (raw = $1) && (ExcludeSchemeRegexp =~ raw || StringSymbolRegexp =~ raw)
        RawHtmlElement.new doc, raw
      else
        TextElement.new doc, content_str
      end
    end
  end
end
