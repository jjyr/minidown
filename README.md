# Minidown

Minidown is yet another markdown parser, with:

* light weight, on dependencies

* pure ruby

* follow GFM(GitHub Flavored Markdown)

## Installation

Add this line to your application's Gemfile:

    gem 'minidown'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minidown

## Usage

```ruby
require 'minidown'

Minidown.parse('*hello*').to_html
#=> "<p><em>hello</em></p>"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
