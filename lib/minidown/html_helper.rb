module Minidown
  module HtmlHelper
    def build_tag name, attr = nil
      content = ''
      yield content if block_given?
      if attr
        attr = attr.map{|k, v| "#{k}=\"#{v}\""}.join ' '.freeze
        "<#{name} #{attr}>#{content}</#{name}>"
      else
        "<#{name}>#{content}</#{name}>"
      end
    end

    def br_tag
      '<br>'
    end
  end
end
