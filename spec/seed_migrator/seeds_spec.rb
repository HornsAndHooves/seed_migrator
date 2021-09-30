require 'spec_helper'

describe SeedMigrator::Seeds do

  before :all do
    class SeedsStub
      include SeedMigrator::Seeds
    end

    @ss = SeedsStub.new
    @path = "#{File.dirname(__FILE__)}/sample"
  end

  it "Should apply all updates in a directory" do
    buffer = @ss.apply_updates(@path)
    expect(buffer.size).to eq 4
    expect(buffer['sample_update']).to eq 'perform_update'
    expect(buffer['01_sequenced_update']).to eq 'perform sequenced update'
    expect(buffer['02_another_update']).to eq 'perform another update'
    expect(buffer["03_foo_update"]).to eq 'perform foo update'
  end

  it "Should load update files in order" do
    files = @ss.send(:get_update_files, @path)
    expect(files).to eq %w(01_sequenced_update.rb 02_another_update.rb 03_foo_update.rb sample_update.rb)
  end

  it "Should return empty array if given a directory that doesn't exist" do
    files = @ss.send(:get_update_files, "#{@path}/foo/bar/baz")
    expect(files).to be_empty
  end

end
