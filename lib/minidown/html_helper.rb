module Minidown
  module HtmlHelper
    def build_tag name, attr = nil
      content = ''
      yield content
      if attr
        attr = attr.map{|k, v| "#{k}=\"#{v}\""}.join ' '
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
