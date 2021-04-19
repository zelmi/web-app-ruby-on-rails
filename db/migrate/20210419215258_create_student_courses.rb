class CreateStudentCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :student_courses do |t|
      t.string :courseId
      t.string :studentId

      t.timestamps
    end
  end
end
