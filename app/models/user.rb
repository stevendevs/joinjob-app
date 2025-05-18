class User < ApplicationRecord
  # Incluir los módulos de Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  # Rolify para gestión de roles
  rolify

  # Asociación con cursos (ajusta si es necesario)
  has_many :courses

  # Mostrar el email al representar el usuario como string
  def to_s
    email
  end

  # Asignar roles automáticamente después de crear el usuario
  after_create :assign_default_role

  private

  def assign_default_role
    if User.count == 1
      # Primer usuario => admin, teacher y student
      self.add_role(:admin)
      self.add_role(:teacher)
      self.add_role(:student)
    else
      # Usuarios posteriores => teacher y student por defecto
      self.add_role(:teacher) unless self.has_role?(:teacher)
      self.add_role(:student) unless self.has_role?(:student)
    end
  end
end
