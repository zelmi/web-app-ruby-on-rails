class CreateTextResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :text_responses do |t|
      t.string :value
      t.string :authorId
      t.string :recepId
      t.string :group_surveyId
      t.string :question

      t.timestamps
    end
  end
end
