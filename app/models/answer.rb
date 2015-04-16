class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
  default_scope { order('accepted DESC') }

  def accept
    question.answers.where("accepted = ?", true).update_all(accepted: false)
    update(accepted: true)
  end
end
