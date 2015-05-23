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
end
