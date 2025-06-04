class Course < ApplicationRecord
    belongs_to :user
      has_rich_text :description
      validates :title, presence: true
      validates :description, presence: true, length: {:minimum => 5}
         def to_s
           title
         end
   end