module SeedMigrator

  # Should be included in seeds.rb to enable running data updates.
  module Seeds
    include UpdateClassLoader

    # Applies all the updates from the given file system path.
    #
    # Basically, requires all the files from the given directory with a .rb
    # suffix, instantiates the class in the file, and calls 'perform_update'
    # on it.  This naturally requires that classes obey the default naming
    # convention, i.e. a file named sample_update.rb should define a class
    # named SampleUpdate.
    #
    # @param [String|Pathname|Symbol] updates_path
    # @return [Hash] A hash or results; update => result
    def apply_updates(updates_path)
      update_files = get_update_files(updates_path)
      results      = {}
      update_files.each { |file|
        update = file.split('.').first
        unless update.blank?
          update_class    = get_update_class(updates_path, update)
          res             = update_class.new.perform_update
          results[update] = res
        end
      }
      results
    end

    # Gets the list of what should be the update files from the given file
    # system path, sorted in alphabetical order.  Returns an empty array if the
    # updates_path is not on the file system or is not a directory.
    # @param [String] updates_path
    # @return [Array]
    def get_update_files(updates_path)
      if File.exist?(updates_path) && File.directory?(updates_path)
        Dir.entries(updates_path).select { |file|
          file.ends_with? '.rb'
        }.sort
      else
        []
      end
    end
    private :get_update_files

  end
end
