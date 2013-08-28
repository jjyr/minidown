module Minidown
  class IndentCodeElement < Element
    def initialize *_
      super
      @lines = [content]
    end

    def parse
      while line = unparsed_lines.shift
        case line
        when Utils::Regexp[:indent_code]
          @lines << $1
        else
          unparsed_lines.unshift line
          break
        end
      end
      unparsed_lines.unshift '```'
      unparsed_lines.unshift *@lines
      unparsed_lines.unshift '```'
    end
  end
end
