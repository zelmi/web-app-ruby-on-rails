class CreateGroupSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :group_surveys do |t|
      t.string :surveyId
      t.string :groupId

      t.timestamps
    end
  end
end
