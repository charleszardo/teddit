class User < ActiveRecord::Base
  validates :username, :email, presence: true
  validates :password_digest, :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  has_many :subs
  has_many :posts, foreign_key: :author_id

  after_initialize :ensure_session_token

  def self.find_by_username_and_password(username, password)
    user = User.find_by_username(username)

    user && user.is_password?(password) ? user : nil
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = generate_token
    self.save
    self.session_token
  end

  private
  def generate_token
    SecureRandom::urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= generate_token
  end
end
