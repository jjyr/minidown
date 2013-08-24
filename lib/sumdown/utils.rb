module Sumdown
  module Utils
    Regexp = {
      blank_line: /\A\s*\z/,
      h1_or_h2: /\A[=-]{3,}([^\s]*)/,
      start_with_shape: /\A(\#{1,6})\s*(.+?)\s*#*\z/,
    }
  end
end
