require 'spec_helper'

describe SeedMigrator::Updater do
  it "Should raise error if undo_update is not overriden" do
    expect{ SeedMigrator::Updater.new.undo_update }.to raise_error(RuntimeError)
  end

  it "Should raise error if perform_update is not overriden" do
    expect{ SeedMigrator::Updater.new.perform_update }.to raise_error(RuntimeError)
  end

  context 'when #execute is called' do
    before { @updater = Class.new(SeedMigrator::Updater).new }


    it 'Should be delegated' do
      expect(@updater).to respond_to(:execute)
    end

    it 'Should be delegated to ActiveRecord::Base.connection' do
      conn = double
      expect(ActiveRecord::Base).to receive(:connection).and_return(conn)
      expect(conn).to receive(:execute).with(:foo).and_return(:bar)

      expect(@updater.execute(:foo)).to eq :bar
    end
  end
end
