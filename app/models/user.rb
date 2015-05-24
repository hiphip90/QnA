class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthabled
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :twitter] 
  before_save :downcase_email
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_and_belongs_to_many :questions_subscribed_to, class_name: "Question", join_table: "new_answer_subscriptions",
                                                                            dependent: :destroy, uniq: true

  validates :email, presence: true, uniqueness: { case_sensitive: false }, 
                    length: { maximum: 150 }, format: { with: VALID_EMAIL_REGEX }

  def subscribe_to_new_answers(question)
    questions_subscribed_to << question
  end

  def subscribed_to?(question)
    questions_subscribed_to.where(id: question.id).any?
  end

  class << self
    def find_for_oauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization
      
      if email = auth.info[:email]
        user = User.where(email: email).first
        unless user
          user = User.build_for_oauth(email)
          user.skip_confirmation!
          user.save!
        end
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      end
      user
    end

    def build_for_oauth(email)
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
    end

    def all_but(user)
      all - [user]
    end

    def send_daily_digest
      find_each do |user|
        DailyMailer.digest(user).deliver_later
      end
    end
  end

  private
    def downcase_email
      self.email.downcase!
    end
end
