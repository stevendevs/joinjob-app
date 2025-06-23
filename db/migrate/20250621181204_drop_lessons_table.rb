class DropLessonsTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :lessons
  end

  def down
    create_table :lessons do |t|
      t.string :title
      t.text :content
      t.bigint :course_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:course_id], name: "index_lessons_on_course_id"
    end
    
    add_foreign_key :lessons, :courses
  end
end