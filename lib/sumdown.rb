require "sumdown/version"
require 'nokogiri'
require 'sumdown/parser'
require 'sumdown/document'
require 'sumdown/utils'
require 'sumdown/element'

module Sumdown
  class << self
    def parse str
      Parser.new str
    end
  end
end
