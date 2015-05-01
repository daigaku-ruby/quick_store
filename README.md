# QuickStore

[![Gem Version](https://badge.fury.io/rb/quick_store.svg)](http://badge.fury.io/rb/quick_store)
[![Travis Build](https://travis-ci.org/daigaku-ruby/quick_store.svg)](https://travis-ci.org/daigaku-ruby/quick_store)

Simple local key-value store based on YAML::Store.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quick_store'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quick_store

## Usage

```ruby
require 'quick_store'
```

### Configuration

```ruby
QuickStore.configure do |config|
  config.file_path = 'path/to/store/file.yml'
  config.key_separator = '|' # default is '/'
end
```

### Storing, fetching, and deleting data
You can store, receive, and remove data from the store by using different methods:

```ruby
# Using dynamic setters and getters
QuickStore.store.arbitrary_key = 'value'      # => "value"
QuickStore.store.arbitrary_key                # => "value"
QuickStore.store.delete_arbitrary_key         # => "value"

# Using the ::set, ::get, and ::delete methods
QuickStore.store.set(:arbitrary_key, 'value') # => "value"
QuickStore.store.get(:arbitrary_key)          # => "value"
QuickStore.store.delete(:arbitrary_key)       # => "value"

# Example for a nested key ('/' is the default key separator)
QuickStore.store.set('a/b/c', 'value')        # => {"b"=>{"c"=>"value"}}

QuickStore.store.get('a/b/c')                 # => "value"
QuickStore.store.get('a/b')                   # => {"c"=>"value"}
QuickStore.store.get('a')                     # => {"b"=>{"c"=>"value"}}

# Removing data for a certain nested key
QuickStore.store.delete('a/b/c')              # => {"b"=>{"c"=>nil}}
QuickStore.get('a')                           # => {"b"=>{"c"=>nil}}

# Removing data for all nested keys under a certain key
QuickStore.store.delete('a')                  # => {"b"=>{"c"=>nil}}
QuickStore.get('a')                           # => nil
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/quick_store/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The quick_store gem is released under the [MIT License](http://opensource.org/licenses/MIT).
