# Facilitates conducting data migrations.
module <%= application_class_name %>DataUpdate
  include SeedMigrator

  # Returns the path where data updates are
  def root_updates_path
    <%= full_application_class_name %>.root.join("db", "data_updates")
  end

  # Updates will run in production, but not in test an dev.
  def should_run?(_)
    Rails.env.production?
  end

end
