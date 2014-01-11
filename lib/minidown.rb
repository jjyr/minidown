require "minidown/version"
require 'minidown/parser'
require 'minidown/utils'
require 'minidown/elements'
require 'minidown/document'

module Minidown
  class << self
    def render str, options = {}
      Parser.new(options).render str
    end
  end
end
