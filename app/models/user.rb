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
  validates :password,
    :presence     => {:if => :password_required?},
    :confirmation => true
  validates :email,
    :presence => true,
    :format   => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}

  # == Scopes ===============================================================
  # == Class Methods ========================================================

  def self.login(email = '', password)
    user = where(:email => email, :verified => true).first.try(:authenticate, password)
  end

  # == Instance Methods =====================================================

  def generate_unique_token
    self.unique_token = SecureRandom.urlsafe_base64
    true
  end

  def password_required?
    self.new_record?
  end

  def set_verified
    self.verified = false
    true
  end

  def verify!
    self.update_column(:unique_token, nil)
    self.update_column(:verified, true)
  end

end
