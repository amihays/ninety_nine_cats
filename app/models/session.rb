class Session < ActiveRecord::Base

  before_validation :ensure_session_token
  validates :user_id, :token, presence: true
  validates :token, uniqueness: true

  belongs_to :user


  private

  def ensure_session_token
    self.token ||= self.class.generate_session_token
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

end
