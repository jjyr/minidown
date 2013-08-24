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

    # define short methods
    # TextElement => te, HtmlElement => ht ... Something => st
    [TextElement, HtmlElement, LineElement].each do |klass|
      method_name = klass.name.split("::").last.scan(/[A-Z]/).join.downcase
      raise 'method name dup' if method_defined? method_name
      define_method method_name do |*args|
        klass.new self, *args
      end
    end

    def parse_line line
      regexp = Sumdown::Utils::Regexp
      case line
      when regexp[:blank_line]
        # blankline
        le line
      when regexp[:h1_or_h2]
        # ======== or -------
        @lines.unshift $2 if $2
        if pre_blank?
          te $1
        else
          he @nodes.pop, (line[0] == '=' ? 'h1' : 'h2')
        end
      when regexp[:start_with_shape]
        # ####h4
        te $2
        he @nodes.pop, "h#{$1.size}"
      else
        te line
      end
    end
    
    private
    def pre_blank?
      node = @nodes.last
      node.nil? || node.blank?
    end
  end
end
