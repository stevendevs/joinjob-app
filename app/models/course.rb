class Course < ApplicationRecord
  belongs_to :user
  has_many :lessons, dependent: :destroy
  
  has_rich_text :description
  validates :title, presence: true
  validates :description, presence: true, length: {minimum: 5}
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  def to_s
    title
  end
  
  # Método para regenerar slug si es necesario
  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end