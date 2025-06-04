# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Crear un usuario para asignarle los cursos
user = User.create!(
  email: "admin@example.com",
  password: "123456",
  password_confirmation: "123456"
)

# Crear 30 cursos con ese usuario
30.times do
  Course.create!(
    title: Faker::Educator.course_name,
    description: Faker::TvShows::GameOfThrones.quote,
    user_id: user.id
  )
end