class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true
  default_scope { order('accepted DESC, created_at DESC') }

  accepts_nested_attributes_for :attachments

  def accept
    question.answers.where("accepted = ?", true).update_all(accepted: false)
    update(accepted: true)
  end
end
