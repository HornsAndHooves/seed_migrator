class <%= migration_class_name %> < ActiveRecord::Migration<%= version_suffix %>
  include <%= application_class_name %>DataUpdate

  def up
    apply_update "<%= data_update_file_name  %>"
  end

  def down
    revert_update "<%= data_update_file_name %>"
  end
end
