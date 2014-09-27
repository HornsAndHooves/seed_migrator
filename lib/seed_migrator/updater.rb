require 'active_record'


module SeedMigrator

  # Adds support for methods which are part of ActiveRecord::Migration interface.
  # This is a convenience feature to make using data updates easier.
  # The module should only implement methods relevant in the context of data
  #   updates.
  module ActiveRecordMigrationCompatible
    # @see ActiveRecord::ConnectionAdapters::DatabaseStatements#execute
    def execute(*args, &block)
      ::ActiveRecord::Base.connection.execute(*args, &block)
    end
  end

  # The base class for all post-release data updates
  #
  # @abstract
  class Updater
    include ::SeedMigrator::ActiveRecordMigrationCompatible

    # Performs the data update.  The subclass must override this method.
    def perform_update
      raise "#{self.class} should override 'update_data'"
    end

    # Reverses the update.  If the update is reversible, this class should
    # be overriden in the subclass.
    def undo_update
      raise "#{self.class} does not support rolling back the update"
    end
  end
end
