module Minidown
  class Parser
    def initialize options = {}
      @options = options.freeze
    end

    def render str
      parse(str).to_html
    end

    protected
    def parse str
      lines = str.split Utils::Regexp[:lines]
      doc = Document.new lines, @options
      doc.parse
      doc
    end
  end
end
