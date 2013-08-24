module Sumdown
  class Line
    attr_reader :content
    attr_reader :type
    
    BlankTypes = [:enter, :blank_line]
    
    def initialize type, content
      @content = content
      @type = type
    end

    def blank?
      BlankTypes.include? type
    end
  end
end
