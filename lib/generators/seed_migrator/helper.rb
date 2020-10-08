module Generators # :nodoc:
  module SeedMigrator # :nodoc:
    # Helper methods for generators
    module Helper
      # Is this a Rails Application or Engine?
      # @return [Boolean]
      def application?
        Rails.application.is_a?(Rails::Application)
      end

      # Name of the application or engine useful for files and directories
      # @return [String]
      def application_name
        if defined?(Rails) && Rails.application
          application_class_name.underscore
        else
          "application"
        end
      end

      # Return data update class name
      def data_update_module_name
        data_update_class = ObjectSpace.each_object(Module).select do |mod|
          mod.included_modules.include?(SeedMigrator)
        end.last.to_s

        class_names = [
          Rails.application.class.name + "DataUpdate",
          "DataUpdate"
        ]

        data_update_class if data_update_class.in?(class_names)
      end

      # Fully qualified name of the application or engine
      # @example AppName::Engine or AppName::Application
      # @return [String]
      def full_application_class_name
        Rails.application.class.name
      end

      # Regular name of the application or engine
      # @example AppName
      # @return [String]
      def application_class_name
        full_application_class_name.split('::').first
      end

      # Class name for use in data_update files
      # @return [String]
      def data_update_class_name
        migration_class_name
      end

      # Name useful for the data update file
      # @return [String]
      def data_update_file_name
        "#{migration_number}_#{file_name}_data_update"
      end

      # Rails 5 uses a different class name for migrations.
      def migration_base_class_name
        "ActiveRecord::Migration" +
          Rails::VERSION::MAJOR >= 5 ? "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" : ""
      end

      # Get default schema
      def schema_name
        @schema_name ||=
          ActiveRecord::Base.connection.current_schema
      end
    end
  end
end
