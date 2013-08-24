module Sumdown
  class Parser
    def initialize str
      @str = str
    end

    def result
      @result ||= parse
    end

    protected
    def parse
      doc = Document.new line_parsers
      doc.parse
    end

    def line_parsers
      @str.lines(/\n|\r\n/).map do |line|
        LineParser.new line
      end
    end
  end
end
