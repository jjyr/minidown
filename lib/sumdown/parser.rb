module Sumdown
  class Parser
    def initialize str
      @str = str
    end

    def to_html
      result.children.to_html
    end

    # return Nokogiri::HTML::DocumentFragment
    def result
      @result ||= parse
    end

    protected
    def parse
      doc = Document.new lines
      doc.parse
    end

    def lines
      @str.lines
    end
  end
end
