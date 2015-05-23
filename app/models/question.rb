class Question < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  has_and_belongs_to_many :subscribers, class_name: "User", join_table: "new_answer_subscriptions",
                                                            dependent: :destroy, uniq: true

  include Votable
  include Commentable

  validates :title, :body, presence: true
  validates :title, length: { maximum: 150 }

  accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes[:file].blank? }, 
                                                                                      allow_destroy: true

  def self.daily_digest
    Question.where('created_at > ?', 1.day.ago)
  end
end