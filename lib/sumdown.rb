require "sumdown/version"

module Sumdown
  class << self
    def parse str
      Parser.new str
    end
  end
end
