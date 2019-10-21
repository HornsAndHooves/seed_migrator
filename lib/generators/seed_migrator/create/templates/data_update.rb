class <%= data_update_class_name %> < SeedMigrator::Updater
  def perform_update
    # <%= class_name %>.create :type_code => "very_shiny"
  end

  # Overridden in case we need to roll back this migration.
  def undo_update
    # <%= class_name %>.where(:type_code => "very_shiny").first.delete
  end
end
