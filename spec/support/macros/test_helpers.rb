module TestHelpers

  def file_path
    File.expand_path('../../test_files/store.yml', __FILE__)
  end

  def use_test_store
    QuickStore::Configuration.send(:new)
    QuickStore.config.instance_variable_set(:@file_path, file_path)
    QuickStore::Store.send(:new)
  end

  def remove_test_files
    dir = File.dirname(file_path)
    FileUtils.remove_dir(dir) if Dir.exist?(dir)
  end
end
