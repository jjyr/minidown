module Sumdown
  class Document
    attr_accessor :lines, :nodes
    
    def initialize lines
      @lines = lines
      @nodes = []
    end

    def parse
      while line = @lines.shift
        parse_line line
      end
      doc = Nokogiri::HTML::DocumentFragment.parse ''
      @nodes.each{|e| doc << e.to_node(doc)}
      doc
    end

    def parse_line line
      regexp = Sumdown::Utils::Regexp
      case line
      when regexp[:blank_line]
        # blankline
        LineElement.new self, line
      when regexp[:h1_or_h2]
        # ======== or -------
        @lines.unshift $1 if $1
        if pre_blank?
          TextElement.new self, line
        else
          HtmlElement.new self, @nodes.pop, (line[0] == '=' ? 'h1' : 'h2')
        end
      when regexp[:start_with_shape]
        # ####h4
        HtmlElement.new self, $2, "h#{$1.size}"
      else
        TextElement.new self, line
      end
    end
    
    private
    def pre_blank?
      node = @nodes.last
      node.nil? || node.blank?
    end
  end
end
