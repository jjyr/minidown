module Minidown
  class Document
    attr_accessor :lines, :nodes, :links_ref, :options
    attr_reader :within_block

    RefRegexp = {
      link_ref_define: /\A\s*\[(.+)\]\:\s+(\S+)\s*(.*)/,
      link_title: /((?<=\").+?(?=\"))/
    }

    TagRegexp ={
      h1h6: /\Ah[1-6]\z/
    }

    def initialize lines, options = {}
      @options = options
      @lines = lines
      @nodes = []
      @within_block = false
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
      when regexp[:unorder_list] =~ line
        # * + -
        indent, str = $1.size, $2
        inblock{ul str, indent}
      when regexp[:order_list] =~ line
        # 1. order
        indent, str = $1.size, $2
        inblock{ol str, indent}
      when regexp[:code_block] =~ line
        # ``` or ~~~
        code_block $1
      when !@within_block && pre_blank? && regexp[:indent_code] =~ line
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
      if @within_block
        yield
      else
        @within_block = true
        yield
        @within_block = false
      end
    end

    def break_if_list line
      node = nodes.last
      if @within_block && (UnorderListElement === node || OrderListElement === node)
        @lines.unshift line
        nodes << nil
      else
        yield
      end
    end
  end
end
