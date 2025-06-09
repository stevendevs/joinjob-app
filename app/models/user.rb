class User < ApplicationRecord
  has_many :courses

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable




         def self.ransackable_attributes(auth_object = nil)
          %w[
            id
            email
            sign_in_count
            current_sign_in_at
            last_sign_in_at
            current_sign_in_ip
            last_sign_in_ip
            confirmed_at
            created_at
            updated_at
          ]
        end
      
        def self.ransackable_associations(auth_object = nil)
          %w[courses]
        end
      







end
