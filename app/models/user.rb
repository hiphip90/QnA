class User < ActiveRecord::Base
  before_save :downcase_email

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :name, presence: true, length: { maximum: 150 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, 
                    length: { maximum: 150 }, format: { with: VALID_EMAIL_REGEX }

  private
    def downcase_email
      self.email.downcase!
    end
end
