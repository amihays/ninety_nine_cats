require 'bcrypt'

class User < ActiveRecord::Base
  validates :user_name, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  # validate :ensure_session_token

  attr_reader :password

  has_many :cats
  has_many :cat_rental_requests
  has_many :sessions

  # def reset_session_token!
  #   self.session_token = generate_session_token
  #   self.save!
  #   self.session_token
  # end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_crendentials(user_name, password)
    user = User.find_by(user_name: user_name)

    return user if user && user.is_password?(password)
  end

  # private
  #
  # def ensure_session_token
  #   self.session_token ||= generate_session_token
  # end
  #
  # def generate_session_token
  #   SecureRandom::urlsafe_base64(16)
  # end
end
