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
    {text: TextElement, html_tag: HtmlElement, newline: LineElement, block: BlockElement, paragraph: ParagraphElement, ul: UnorderListElement}.each do |name, klass|
      define_method name do |*args|
        klass.new(self, *args).parse
      end
    end

    def parse_line line
      regexp = Minidown::Utils::Regexp
      case
      when regexp[:blank_line] =~ line
        # blankline
        newline line
      when !pre_blank? && regexp[:h1_or_h2] =~ line
        # ======== or -------
        lines.unshift $2 if $2 && !$2.empty?
        html_tag nodes.pop, (line[0] == '=' ? 'h1' : 'h2')
      when regexp[:start_with_shape] =~ line
        # ####h4
        text $2
        html_tag nodes.pop, "h#{$1.size}"
      when regexp[:start_with_quote] =~ line
        # > blockquote        
        block $1
      when pre_blank? && regexp[:unorder_list] =~ line
        # * + -
        ul $1
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
