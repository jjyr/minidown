require 'minidown/html_helper'

module Minidown
  class Element
    attr_accessor :content, :doc, :nodes, :children

    include HtmlHelper

    def raw_content
      @content
    end

    def raw_content= str
      @content = str
    end

    def unparsed_lines
      doc.lines
    end
    
    def initialize doc, content
      @doc = doc
      @nodes = doc.nodes
      @content = content
      @children = []
    end

    def parse
      raise NotImplementedError, 'method parse not implemented'
    end

    def to_html
      raise NotImplementedError, 'method to_html not implemented'
    end

    def blank?
      false
    end
  end
end
