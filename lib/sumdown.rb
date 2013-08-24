require "sumdown/version"
require 'nokogiri'
require 'sumdown/parser'
require 'sumdown/elements'
require 'sumdown/document'
require 'sumdown/utils'

module Sumdown
  class << self
    def parse str
      Parser.new str
    end
  end
end
