class Lesson < ApplicationRecord
  belongs_to :course

  validates :title, :content, :course, presence: true


end
