class User < ActiveRecord::Base

  # == Constants ============================================================
  
  # == Extensions ===========================================================
  has_secure_password  
  
  # == Attributes ===========================================================
  attr_accessible :email, :password, :password_confirmation

  # == Relationships ========================================================
  
  # == Callbacks ============================================================
  before_create :generate_unique_token, :set_verified
  after_create  :deliver_verification_email

  # == Validations ==========================================================
  validates :password,
    :presence     => {:if => :password_required?},
    :confirmation => true
  validates :email,
    :presence   => true,
    :uniqueness => true,
    :format     => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validate :immutable_email,
    :on      => :update,
    :if      => :email_changed?

  # == Scopes ===============================================================
  # == Class Methods ========================================================

  def self.login(email = '', password)
    user = where(:email => email, :verified => true).first.try(:authenticate, password)
  end

  # == Instance Methods =====================================================

  def deliver_verification_email
    UserMailer.verification_email(self).deliver
  end

  def generate_unique_token(save = false)
    token = SecureRandom.urlsafe_base64
    if save
      self.update_column(:unique_token, token)
    else
      self.unique_token = token
    end
    true
  end

  def password_required?
    self.new_record?
  end

  def set_verified
    self.verified = false
    true
  end

  def send_password_reset!
    self.generate_unique_token(true)
    UserMailer.reset_password(self).deliver
  end

  def verify!
    self.update_column(:unique_token, nil)
    self.update_column(:verified, true)
  end

  def immutable_email
    errors.add(:email, 'You cannot change your email address')
  end

end
