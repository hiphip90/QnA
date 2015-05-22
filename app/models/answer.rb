class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  include Votable
  include Commentable

  validates :body, presence: true
  
  default_scope { order('accepted DESC, created_at DESC') }

  accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes[:file].blank? }, 
                                                                                      allow_destroy: true

  after_create { Reputation.update(user, :create_answer, first: first?, to_own_question: to_own_question?) }
  after_destroy { Reputation.update(user, :destroy_answer, first: first?, to_own_question: to_own_question?, accepted: accepted?) }

  def accept
    question.answers.where("accepted = ?", true).each do |answer|
      answer.update(accepted: false)
      Reputation.update(answer.user, :recall_accept_answer)
    end
    update(accepted: true)
    Reputation.update(user, :accept_answer)
  end

  def first?
    !question.answers.where('created_at < ?', created_at).any?
  end

  def to_own_question?
    user_id == question.user_id
  end

end
