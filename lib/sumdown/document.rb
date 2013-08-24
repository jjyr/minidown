module Sumdown
  class Document
    def initialize lines
      @lines = lines
      @nodes = []
    end

    def parse
      while line = @lines.shift
        
      end
    end

    def parse_line line
      case line
        # ========
      when /\A={3,}/
        if pre_blank?
          Line.new :text, line
        end
      end
    end
    
    private
    def pre_blank?
      node = @nodes.last
      node.nil? || node.blank?
    end
    
  end
end
