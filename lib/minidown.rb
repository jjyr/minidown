require "minidown/version"
require 'nokogiri'
require 'minidown/parser'
require 'minidown/elements'
require 'minidown/document'
require 'minidown/utils'

module Minidown
  class << self
    def parse str
      Parser.new str
    end
  end
end
