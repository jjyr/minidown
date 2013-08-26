module Minidown
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

    # define short methods
    {text: TextElement, html_tag: HtmlElement, newline: LineElement, block: BlockElement, paragraph: ParagraphElement}.each do |name, klass|
      define_method name do |*args|
        klass.new(self, *args).parse
      end
    end

    def parse_line line
      regexp = Minidown::Utils::Regexp
      case line
      when regexp[:blank_line]
        # blankline
        newline line
      when regexp[:h1_or_h2]
        # ======== or -------
        if pre_blank?
          paragraph line
        else
          lines.unshift $2 if $2 && !$2.empty?
          html_tag nodes.pop, (line[0] == '=' ? 'h1' : 'h2')
        end
      when regexp[:start_with_shape]
        # ####h4
        text $2
        html_tag nodes.pop, "h#{$1.size}"
      when regexp[:start_with_quote]
        # > blockquote        
        block $1
      when regexp[:unorder_list]
        # * + -         
      else
        # paragraph
        paragraph line
      end
    end
    
    private
    def pre_blank?
      node = @nodes.last
      node.nil? || node.blank?
    end
  end
end
