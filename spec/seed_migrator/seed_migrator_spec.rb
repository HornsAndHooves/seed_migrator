require "spec_helper"

describe SeedMigrator do
  before :all do

    class UpdateStub
      include SeedMigrator

      def root_updates_path
        "#{File.dirname(__FILE__)}/sample"
      end

      def should_run?(update_name)
        update_name != "03_foo_update" && update_name != "foo_update"
      end
    end

    @up = UpdateStub.new
  end

  it "applies updates" do
    expect(@up.apply_update(:sample_update)).to eq "perform_update"
  end

  it "reverts updates" do
    expect(@up.revert_update(:sample_update)).to eq "undo_update"
  end

  it "applies updates if the updates have a prefix" do
    expect(@up.apply_update("01_sequenced_update")).to eq "perform sequenced update"
  end

  it "applies updates is the update name omits the prefix" do
    expect(@up.apply_update(:sequenced_update)).to eq "perform sequenced update"
    expect(@up.apply_update("another_update") ).to eq "perform another update"
  end

  it "run condition prevents apply from running" do
    expect(@up.apply_update("03_foo_update")).to be_nil
  end

  it "run condition prevents revert from running" do
    expect(@up.revert_update("03_foo_update")).to be_nil
  end

  it "run condition prevents apply from running when the update name given omits the prefix" do
    expect(@up.apply_update("foo_update")).to be_nil
  end

  it "raises a LoadError if given an update that does not exist, even if it does not run" do
    expect{
      @up.apply_update("bar")
    }.to raise_error(LoadError)
  end
end
