class Question < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }

  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { maximum: 150 }
end
