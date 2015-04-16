class Question < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, presence: true
  validates :title, length: { maximum: 150 }

  def accept(answer)
    return false unless answer.question_id == self.id
    answers.where("accepted = ?", true).update_all(accepted: false)
    answer.update(accepted: true)
  end
end
