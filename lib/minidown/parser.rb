module Minidown
  class Parser
    def initialize str
      @str = str
    end

    # return Minidown::Document
    def result
      @result ||= parse
    end

    protected
    def parse
      doc = Document.new lines
      doc.parse
      doc
    end

    def lines
      @str.split Utils::Regexp[:lines]
    end
  end
end
