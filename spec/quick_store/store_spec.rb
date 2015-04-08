require 'spec_helper'

describe QuickStore::Store do

  subject { QuickStore::Store.send(:new) }

  it { is_expected.to respond_to :get }
  it { is_expected.to respond_to :set }
  it { is_expected.to respond_to :file }

  it "raises an error if used without a configured file_path" do
    allow_any_instance_of(QuickStore::Configuration).to receive(:file_path) { nil }
    expect { QuickStore::Store.send(:new) }.to raise_error
  end

  it "creates the store file in the given directory on access" do
    QuickStore::Store.call_an_arbitrary_method
    expect(File.exist?(file_path)).to be_truthy
  end

  it "allows setting arbitrary keys by setter methods" do
    expect { QuickStore::Store.brownie = "brownie" }.not_to raise_error
  end

  it "allows getting subsequently set keys" do
    QuickStore::Store.carrots = "carrots"
    expect(QuickStore::Store.carrots).to eq "carrots"
  end

  it "returns nil for not set simple keys" do
    expect(QuickStore::Store.hamburger).to be_nil
  end

  it "returns nil for not set nested keys" do
      key = "pastries/muffins/savory"
      expect(QuickStore::Store.get(key)).to be_nil
    end

  it "raises an method missing errror for non getter/setter methods" do
    expect { QuickStore::Store.arbitrary_method(1, 2) }
      .to raise_error NoMethodError
  end

  it "responds to ::get" do
    expect(QuickStore::Store).to respond_to :get
  end

  it "responds to ::set" do
    expect(QuickStore::Store).to respond_to :set
  end

  it "responds to ::file" do
    expect(QuickStore::Store).to respond_to :file
  end

  describe "::get" do
    it "returns the value of the given key" do
      toast = 'toast'
      QuickStore::Store.toast = toast
      expect(QuickStore::Store.get(:toast)).to eq toast
    end

    it "gets the value hash for a given partly key" do
      base_key = 'pastries'
      second_key = 'muffins'
      third_key = 'sweet'
      key = "#{base_key}/#{second_key}/#{third_key}"
      muffin = 'raspberry cream muffin'
      hash = { second_key => { third_key => muffin } }

      QuickStore::Store.set(key, muffin)
      expect(QuickStore::Store.get(base_key)).to eq hash
    end
  end

  describe "::set" do
    it "sets the value for the given key" do
      juice = 'orange juice'
      QuickStore::Store.set(:juice, juice)
      expect(QuickStore::Store.juice).to eq juice
    end

    it "sets the value for the given nested key" do
      key = "pastries/muffins/sweet"
      muffin = 'blueberry muffin'

      QuickStore::Store.set(key, muffin)
      expect(QuickStore::Store.get(key)).to eq muffin
    end

    it "sets the value for the given nested key" do
      key = "pastries/muffins/sweet"
      muffin = 'apple walnut muffin'

      QuickStore::Store.set(key, muffin)
      expect(QuickStore::Store.get(key)).to eq muffin
    end
  end

  describe "::file" do
    it "returns the storage file path" do
      expect(QuickStore::Store.file).to eq QuickStore.config.file_path
    end
  end

  it "raises an error if the related getter for a setter is already defined" do
    expect { QuickStore::Store.clone = 'defined' }.to raise_error
  end
end
