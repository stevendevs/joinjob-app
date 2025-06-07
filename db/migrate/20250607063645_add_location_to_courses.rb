class AddLocationToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :location, :string
    add_column :courses, :latitude, :decimal
    add_column :courses, :longitude, :decimal
  end
end
