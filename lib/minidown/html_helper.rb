module Minidown
  module HtmlHelper
    def build_tag name
      content = ''
      yield content
      "<#{name}>#{content}</#{name}>"
    end

    def br_tag
      '<br>'
    end
  end
end
