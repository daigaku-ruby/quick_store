require 'spec_helper'

describe QuickStore do
  describe '.config' do
    it 'returns a QuickStore::Configuration instance' do
      expect(QuickStore.config).to be_a QuickStore::Configuration
    end
  end

  describe '.store' do
    it 'retuns the QuickStore::Store class' do
      expect(QuickStore.store).to be QuickStore::Store
    end

    it 'can be used to set values' do
      expect { QuickStore.store.muffin = 'blueberry muffin' }.not_to raise_error
    end
  end

  describe '.configure' do
    it 'allows passing in a block' do
      expect { QuickStore.configure }.not_to raise_error
    end

    it 'allows setting the file_path' do
      QuickStore.configure do |config|
        config.file_path = file_path
      end

      expect(QuickStore.config.file_path).to eq file_path
    end

    it 'allows setting the key_separator' do
      QuickStore.configure do |config|
        config.key_separator = '.'
      end

      expect(QuickStore.config.key_separator).to eq '.'
    end

    it 'returns the QuickStore::Configuration' do
      config = QuickStore.configure
      expect(config).to be_a QuickStore::Configuration
    end
  end
end
