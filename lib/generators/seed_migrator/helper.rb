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

      # Version suffix for Rails 5 migrations.
      #
      # @return [String]
      def version_suffix
        major_version, minor_version, *_ = Rails.version.split(".")

        return "" if major_version.to_i < 5

        "[#{major_version}.#{minor_version}]"
      end
    end
  end
end
