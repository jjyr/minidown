module Minidown
  class Document
    attr_accessor :lines, :nodes, :links_ref

    RefRegexp = {
      link_ref_define: /\A\s*\[(.+)\]\:\s+(\S+)\s*(.*)/,
      link_title: /((?<=\").+?(?=\"))/
    }

    TagRegexp ={
      h1h6: /\Ah[1-6]\z/
    }
    
    def initialize lines
      @lines = lines
      @nodes = []
      @inblock = false
      @links_ref = {}
    end

    def parse
      parse_references
      
      while line = @lines.shift
        parse_line line
      end
    end

    def to_html
      @html ||= (doc = ''
       @nodes.each{|e| doc << e.to_html}
       doc)
    end

    # define short methods
    {text: TextElement, html_tag: HtmlElement, newline: LineElement, block: BlockElement, paragraph: ParagraphElement, ul: UnorderListElement, ol: OrderListElement, code_block: CodeBlockElement, dividing_line: DividingLineElement, indent_code: IndentCodeElement}.each do |name, klass|
      define_method name do |*args|
        klass.new(self, *args).parse
      end
    end

    def parse_references
      while line = @lines.pop
        line.gsub! RefRegexp[:link_ref_define] do
          id, url = $1, $2
          $3 =~ RefRegexp[:link_title]
          title = $1
          links_ref[id.downcase] = {url: url, title: title}
          ''
        end
        unless line.empty?
          @lines << line
          break
        end
      end
    end

    def parse_line line
      regexp = Minidown::Utils::Regexp
      case
      when regexp[:blank_line] =~ line
        # blankline
        newline line
      when !pre_blank? && (result = regexp[:h1_or_h2] =~ line; next_line = $2; result) && ParagraphElement === nodes.last
        # ======== or -------
        break_if_list line do
          lines.unshift next_line if next_line && !next_line.empty?
          html_tag nodes.pop, (line[0] == '=' ? 'h1' : 'h2')
        end
      when regexp[:start_with_shape] =~ line
        # ####h4
        break_if_list line do
          text $2
          html_tag nodes.pop, "h#{$1.size}"
        end
      when regexp[:start_with_quote] =~ line
        # > blockquote        
        inblock{block $1}
      when regexp[:dividing_line] =~ line
        # * * * - - -
        break_if_list line do
          dividing_line line
        end
      when (pre_blank? || UnorderListElement === nodes.last) && regexp[:unorder_list] =~ line
        # * + -
        inblock{ul $1}
      when (pre_blank? || OrderListElement === nodes.last) && regexp[:order_list] =~ line
        # 1. order
        inblock{ol $1}
      when regexp[:code_block] =~ line
        # ```
        code_block $1
      when !@inblock && pre_blank? && regexp[:indent_code] =~ line
        #    code
        indent_code $1
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

    def inblock
      if @inblock
        yield
      else
        @inblock = true
        yield
        @inblock = false
      end
    end

    def break_if_list line
      node = nodes.last
      if @inblock && (UnorderListElement === node || OrderListElement === node)
        @lines.unshift line
        nodes << nil
      else
        yield
      end
    end
  end
end
