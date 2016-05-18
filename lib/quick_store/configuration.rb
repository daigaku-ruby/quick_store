module QuickStore
  # The Configuration class is used internally by QuickStore to create a
  # singleton configuration.
  # The *key_separator* defines the character which can be used to access nested
  # store items (default is "/").
  # The *file_path* determines where the YAML file is stored.
  class Configuration
    attr_accessor :key_separator, :file_path

    def initialize
      @key_separator = '/'
    end
  end
end
