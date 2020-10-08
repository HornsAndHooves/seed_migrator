class <%= migration_class_name %> < <%= migration_base_class_name %>
  include <%= data_update_module_name %>

  set_role "<%= schema_name %>"

  def up
    apply_update "<%= data_update_file_name  %>"
  end

  def down
    revert_update "<%= data_update_file_name %>"
  end
end
