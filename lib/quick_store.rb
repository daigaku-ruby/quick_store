require 'quick_store/version'
require 'quick_store/exceptions'
require 'quick_store/configuration'
require 'quick_store/store'

# Allows configuring a YAML store and accessing the configured YAML store
# through the .store method.
module QuickStore
  class << self
    attr_accessor :configuration
  end

  # Configures the QuickStore::Store
  #
  #   QuickStore.configure do |config|
  #     config.file_path = 'path/to/store/file.yml'
  #     config.key_separator = '|' # default is '/'
  #   end
  def self.configure
    yield(config) if block_given?
    raise FilePathNotConfiguredError unless config.file_path
    config
  end

  # Returns the QuickStore::Configuration.
  def self.config
    self.configuration ||= Configuration.new
  end

  # Returns the QuickStore::Store.
  # You can store and receive data from the store using different methods:
  #
  #   # Using dynamic setters and getters
  #   QuickStore.store.arbitrary_key = 'value' # => "value"
  #   QuickStore.store.arbitrary_key           # => "value"
  #
  #   # Using the ::set and ::get methods
  #   QuickStore.store.set(:arbitrary_key, 'value') # => "value"
  #   QuickStore.store.get(:arbitrary_key)          # => "value"
  #
  #   # Example for a nested key ('/' is the default key separator)
  #   QuickStore.store.set('a/b/c', 'value') # => {"b"=>{"c"=>"value"}}
  #   QuickStore.store.get('a/b/c')          # => "value"
  #   QuickStore.store.get('a/b')            # => {"c"=>"value"}
  #   QuickStore.store.get('a')              # => {"b"=>{"c"=>"value"}}
  def self.store
    QuickStore::Store
  end
end
