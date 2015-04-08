require "quick_store/version"
require "quick_store/store"

module QuickStore

  NO_FILE_PATH_CONFIGURED = "Please configure a file_path for your QuickStore!"

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
    yield(self.config)
    raise(NO_FILE_PATH_CONFIGURED) unless self.config.file_path
    self.config
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

  class Configuration
    attr_accessor :key_separator, :file_path

    def initialize
      @key_separator = '/'
    end
  end

end
