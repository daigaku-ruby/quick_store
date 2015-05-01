require 'active_support'
require 'yaml/store'
require 'fileutils'
require 'singleton'

module QuickStore

  class Store
    include Singleton

    attr_reader :file

    def initialize
      @file = QuickStore.config.file_path

      raise(QuickStore::NO_FILE_PATH_CONFIGURED) unless @file

      directory = File.dirname(@file)
      FileUtils.makedirs(directory) unless Dir.exist?(directory)

      @db = YAML::Store.new(@file)
    end

    # Sets the value for the given key.
    # If the key is of structure "a/b/c" then the value is saved as a
    # nested Hash.
    #
    #   QuickStore::Store.instance.set('a', 'value')
    #   # => "value"
    #
    #   QuickStore::Store.instance.set('a/b', 'value')
    #   # => { "c": "value" }
    #
    #   QuickStore::Store.instance.set('a/b/c', 'value')
    #   # => { "b": { "c": "value" } }
    def set(key, value)
      keys = key.to_s.split(QuickStore.config.key_separator)
      base_key = keys.shift

      if keys.empty?
        final_value = value
      else
        final_value = keys.reverse.inject(value) { |v, k| { k => v } }
      end

      old_value = get(base_key)

      if old_value.is_a?(Hash) && final_value.is_a?(Hash)
        updated_values = old_value ? old_value.deep_merge(final_value) : final_value
      else
        updated_values = final_value
      end

      @db.transaction { @db[base_key.to_s] = updated_values }
    end

    # Gets the value for the given key.
    # If the value was saved for a key of structure "a/b/c" then the value is
    # searched in a nested Hash, like: {"a"=>{"b"=>{"c"=>"value"}}}.
    # If there is a value stored within a nested hash, it returns the appropriate
    # Hash if a partial key is used.
    #
    #   QuickStore::Store.instance.get('a')
    #   # => {"b"=>{"c"=>"value"}}
    #
    #   QuickStore::Store.instance.get('a/b')
    #   # => {"c"=>"value"}
    #
    #   QuickStore::Store.instance.get('a/b/c')
    #   # => "value"
    def get(key)
      keys = key.to_s.split(QuickStore.config.key_separator)
      base_key = keys.shift

      @db.transaction do
        data = @db[base_key.to_s]

        if data
          keys.reduce(data) { |value, key| value ? value = value[key] : nil }
        end
      end
    end

    def delete(key)
      if key.to_s =~ Regexp.new(QuickStore.config.key_separator)
        set(key, nil)
      else
        @db.transaction { @db.delete(key.to_s) }
      end
    end

    class << self
      def get(key)
        instance.get(key)
      end

      def set(key, value)
        instance.set(key, value)
      end

      def file
        instance.file
      end

      def delete(key)
        instance.delete(key)
      end

      # Defines getter and setter methods for arbitrarily named methods.
      #
      #   QuickStore::Store.answer = 42 # saves 'answer: 42' to the store
      #   # => 42
      #
      #   QuickStore::Store.answer
      #   # => 42
      def method_missing(method, *args, &block)
        if method =~ /.*=$/
          if singleton_methods.include?(method.to_s.chop.to_sym)
            raise "There is a \"#{method.to_s.chop}\" instance method already " +
            "defined. This will lead to problems while getting values " +
            "from the store. Please use another key than " +
            "#{singleton_methods.map(&:to_s)}."
          end

          instance.set(method.to_s.gsub(/=$/, ''), args[0])
        elsif method =~/\Adelete\_.*$/
          instance.delete(method.to_s.gsub(/\Adelete\_/, ''))
        elsif args.count == 0
          instance.get(method)
        else
          super
        end
      end
    end
  end

end
