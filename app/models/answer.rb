class Answer < ActiveRecord::Base
  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  include Votable
  include Commentable
  include AffectsReputation::Answer

  validates :body, presence: true
  
  default_scope { order('accepted DESC, created_at DESC') }

  accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes[:file].blank? }, 
                                                                                      allow_destroy: true

  after_create :send_emails

  def accept
    run_callbacks :accept do
      Answer.transaction do
        question.answers.find_by(accepted: true).try(:recall_accept)
        update(accepted: true)
      end
    end
  end

  def recall_accept
    run_callbacks :recall_accept do
      update(accepted: false)
    end
  end

  def send_emails
    SubscriptionsMailer.new_answer(question.user, self).deliver_later
    question.subscribers.each do |subscriber|
      SubscriptionsMailer.new_answer(subscriber, self).deliver_later
    end
  end
end
