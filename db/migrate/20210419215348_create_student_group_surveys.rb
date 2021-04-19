class CreateStudentGroupSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :student_group_surveys do |t|
      t.string :student_id
      t.string :group_surveyId
      t.boolean :completed

      t.timestamps
    end
  end
end
