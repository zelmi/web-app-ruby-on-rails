class CreateStudentGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :student_groups do |t|
      t.string :studentId
      t.string :groupId

      t.timestamps
    end
  end
end
