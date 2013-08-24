require 'element/html_element'
require 'element/line_element'
require 'element/text_element'

module Sumdown
  class Eelement
    attr_reader :content
        
    BlankTypes = [:enter, :blank_line]
    
    def initialize doc, content
      @doc = doc
      @nodes = doc.nodes
      @content = content
      parse
    end

    def parse
      raise NotImplementedError, 'method parse not implemented'
    end

    def to_node
      raise NotImplementedError, 'method to_node not implemented'
    end

    def blank?
      false
    end
  end
end
