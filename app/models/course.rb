# app/models/course.rb
class Course < ApplicationRecord
  belongs_to :user
  
  has_many_attached :images
  has_rich_text :description
  
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # 🔧 AGREGAR ESTA CONFIGURACIÓN DE GEOCODIFICACIÓN
  geocoded_by :location, latitude: :latitude, longitude: :longitude
  after_validation :geocode, if: :will_save_change_to_location?
  
  def to_s
    title
  end
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  # Métodos helper para verificar geocodificación
  def geocoded?
    latitude.present? && longitude.present?
  end
  
  def coordinates
    [latitude, longitude] if geocoded?
  end




  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      title
      short_description
      description
      language
      level
      price
      user_id
      created_at
      updated_at
    ]
  end
 
  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end


  LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]
  def self.levels
    LEVELS.map { |level| [level, level] }
  end


# PublicActivity
include PublicActivity::Model
tracked owner: Proc.new{ |controller, model| controller.current_user }






  
end