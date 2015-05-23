class CreateNewAnswerSubscriptions < ActiveRecord::Migration
  def change
    create_table :new_answer_subscriptions do |t|
      t.integer :question_id
      t.integer :user_id
    end
  end
end
