class Question < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, presence: true
  validates :title, length: { maximum: 150 }

  def has_accepted_answer?
    answers.where("accepted = ?", true).any?
  end

  def accept(answer)
    return false unless answer.question_id == self.id
    answers.where("accepted = ?", true).first.update(accepted: false) if self.has_accepted_answer?
    answer.update(accepted: true)
  end
end
