class RemoveIsActiveColumnFromTrips < ActiveRecord::Migration[6.0]
  def change
    remove_column :trips, :is_archive
  end
end
