require 'spec_helper'

describe QuickStore::Configuration do
  it { is_expected.to respond_to :key_separator }
  it { is_expected.to respond_to :key_separator= }
  it { is_expected.to respond_to :file_path }
  it { is_expected.to respond_to :file_path= }

  it 'has the default key separator "/"' do
    expect(QuickStore::Configuration.new.key_separator).to eq '/'
  end
end
