class AddActiveColToAllTables < ActiveRecord::Migration[6.0]
  def change
    add_column :drivers, :is_active, :boolean, default: true
    add_column :passengers, :is_active, :boolean, default: true
    add_column :trips, :is_archive, :boolean, default: false
  end
end
