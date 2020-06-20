module QuickStore
  class Error < StandardError; end

  class FilePathNotConfiguredError < Error
    def initialize
      super('Please configure a file_path for your QuickStore!')
    end
  end

  class NotAllowedKeyError < Error
    def initialize(key, forbidden_names)
      super(
        "There is a \"#{key.to_s.chop}\" instance method already " \
        'defined. This will lead to problems while getting values ' \
        "from the store. Please use another key than #{forbidden_names}."
      )
    end
  end
end
