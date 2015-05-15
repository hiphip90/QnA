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

  validates :email, presence: true, uniqueness: { case_sensitive: false }, 
                    length: { maximum: 150 }, format: { with: VALID_EMAIL_REGEX }

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
  end

  private
    def downcase_email
      self.email.downcase!
    end
end
