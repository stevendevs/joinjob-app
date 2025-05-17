class Course < ApplicationRecord
  belongs_to :user
  has_rich_text :description

  extend FriendlyId
  # Usamos un solo `friendly_id`, con método personalizado
  friendly_id :generated_slug, use: :slugged

  validates :title, :short_description, :language, :price, :level,  presence: true
  validates :description, presence: true, length: { minimum: 5 }

  def to_s
    title
  end

  def generated_slug
    require 'securerandom'
    @random_slug ||= SecureRandom.hex(4)
  end

  # Necesario para regenerar slug solo si está en blanco
  def should_generate_new_friendly_id?
    slug.blank?
  end


# PublicActivity
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
end
