class User < ActiveRecord::Base

  # == Constants ============================================================
  
  # == Extensions ===========================================================
  has_secure_password  
  
  # == Attributes ===========================================================
  attr_accessible :email, :password, :password_confirmation

  # == Relationships ========================================================
  
  # == Callbacks ============================================================
  before_create :generate_unique_token, :set_verified

  # == Validations ==========================================================
  validates_presence_of :email, :password

  # == Scopes ===============================================================
  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def generate_unique_token
    self.unique_token = SecureRandom.urlsafe_base64
  end

  def set_verified
    self.verified = false
  end

end
