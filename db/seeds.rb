require 'faker'

# Limpiar datos existentes
Course.destroy_all
User.destroy_all

puts "Datos existentes eliminados."

# Crear un usuario para asignarle los cursos
user = User.find_or_create_by(email: "raul@gmail.com") do |u|
  u.password = "123456"
  u.password_confirmation = "123456"
  u.username = "raul123"
end

# No imprimir el objeto user directamente
puts "Usuario creado con ID: #{user.id}"

if user.persisted?
  # Crear 30 cursos con ese usuario
  30.times do |i|
    course = Course.create!(
      title: Faker::Educator.course_name,
      description: Faker::TvShows::GameOfThrones.quote,
      user_id: user.id
    )
    
    puts "Curso #{i + 1} creado con ID: #{course.id}"
  end
  
  puts "¡Seeds completados! Se crearon 30 cursos."
else
  puts "Error: No se pudo crear el usuario"
end