require 'yaml/store'
require 'fileutils'
require 'singleton'

module QuickStore
  # Provides setter and getter methods for inserting values into the YAML store,
  # fetching (nested) values, and removing (nested) items from the YAML store.
  class Store
    include Singleton

    attr_reader :file

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
          ensure_not_singleton_method!(method)
          instance.set(method.to_s.gsub(/=$/, ''), args[0])
        elsif method =~ /\Adelete\_.*$/
          instance.delete(method.to_s.gsub(/\Adelete\_/, ''))
        elsif args.count == 0
          instance.get(method)
        else
          super
        end
      end

      private

      def ensure_not_singleton_method!(key)
        return unless singleton_methods.include?(key.to_s.chop.to_sym)
        raise NotAllowedKeyError.new(key, singleton_methods.map(&:to_s))
      end
    end

    def initialize
      @file = QuickStore.config.file_path
      raise FilePathNotConfiguredError unless @file

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
      keys     = key.to_s.split(QuickStore.config.key_separator)
      base_key = keys.shift

      final_value    = final_value(keys, value)
      old_value      = get(base_key)
      updated_values = updated_values(old_value, final_value)

      @db.transaction { @db[base_key.to_s] = updated_values }
    end

    # Gets the value for the given key.
    # If the value was saved for a key of structure "a/b/c" then the value is
    # searched in a nested Hash, like: {"a"=>{"b"=>{"c"=>"value"}}}.
    # If there is a value stored within a nested hash, it returns the
    # appropriate Hash if a partial key is used.
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
          keys.reduce(data) do |value, store_key|
            value ? value[store_key] : nil
          end
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

    private

    def final_value(keys, value)
      if keys.empty?
        value
      else
        keys.reverse.inject(value) { |final_value, key| { key => final_value } }
      end
    end

    def updated_values(old_value, final_value)
      if old_value.is_a?(Hash) && final_value.is_a?(Hash)
        deep_merge(old_value, final_value)
      else
        final_value
      end
    end

    def deep_merge(old_hash, new_hash)
      final_hash = old_hash.dup

      new_hash.each_pair do |key, other_value|
        old_value = final_hash[key]

        if old_value.is_a?(Hash) && other_value.is_a?(Hash)
          final_hash[key] = deep_merge(old_value, other_value)
        else
          final_hash[key] = other_value
        end
      end

      final_hash
    end
  end
end
