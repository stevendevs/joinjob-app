# Crea al usuario y lo asigna a la variable 'user'
user = User.create!(email: "ke@gmail.com", password: "123456", password_confirmation: "123456")

# Carga de librería
require 'faker'

# Crea cursos usando el usuario
30.times do
  Course.create!(
    title: Faker::Educator.course_name,
    description: Faker::TvShows::GameOfThrones.quote,
    user_id: user.id,
    short_description: Faker::Quote.famous_last_words,
    language: Faker::ProgrammingLanguage.name,
    level: 'Beginner',
    price: Faker::Number.between(from: 1000, to: 20000)
  )
end
