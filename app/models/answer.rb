class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  include Votable
  include Commentable
  include AffectsReputation::Answer

  validates :body, presence: true
  
  default_scope { order('accepted DESC, created_at DESC') }

  accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes[:file].blank? }, 
                                                                                      allow_destroy: true

  def accept
    question.answers.where("accepted = ?", true).each do |answer|
      answer.recall_accept
    end
    update(accepted: true)
  end

  def recall_accept
    update(accepted: false)
  end

  def first?
    !question.answers.where('created_at < ?', created_at).any?
  end

  def to_own_question?
    user_id == question.user_id
  end

end
