class User < ApplicationRecord
  rolify
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



        extend FriendlyId
        friendly_id :email, use: :slugged
  
      
        def self.ransackable_associations(auth_object = nil)
          %w[courses]
        end
      
        rolify
        after_create :assign_default_role

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
      

        # User can´t have any role
        validate :must_have_a_role, on: :update

        private
        def must_have_a_role
          unless roles.any?
            errors.add(:roles, "must have at least one role")
          end
        end



end
