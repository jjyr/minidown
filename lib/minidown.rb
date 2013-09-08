require "minidown/version"
require 'minidown/parser'
require 'minidown/utils'
require 'minidown/elements'
require 'minidown/document'

module Minidown
  class << self
    # return Minidown::Document
    def parse str
      Parser.new(str).result
    end
  end
end
