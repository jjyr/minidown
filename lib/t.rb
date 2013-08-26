$: << '.'
require './minidown'
str = <<HERE
*   A list item with a blockquote:

    > This is a blockquote
        > inside a list item.
HERE

puts Minidown.parse(str).to_html
