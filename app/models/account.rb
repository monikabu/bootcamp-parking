class Account < ActiveRecord::Base
  class NotAuthorized < StandardError 
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :owner, class_name: "Person"
  before_create :set_person_first_name_from_email

  attr_accessor :password
  before_create :set_encrypted_password_on_creation
  
  validates_confirmation_of :password, :on => :create
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  PEPPER = '9782901ee15a5651b9f5'
  STRETCHES = 10

  def valid_password?(password)
    return false if encrypted_password.blank?
    bcrypt = ::BCrypt::Password.new(encrypted_password)
    password = ::BCrypt::Engine.hash_secret("#{password}#{PEPPER}", bcrypt.salt)
    password == encrypted_password
  end

  def password_digest(password)
    ::BCrypt::Password.create("#{password}#{PEPPER}", :cost => STRETCHES).to_s
  end

  def set_encrypted_password_on_creation
    self.encrypted_password = password_digest(password)
  end

  def self.authenticate(email, password)
    account = Account.find_by_email(email)
    if account && account.valid_password?(password)
      account
    else
      nil
    end 
  end

  def self.authenticate!(email, password)
    if account = authenticate(email, password)
      account
    else
      raise Account::NotAuthorized
    end
  end

  def set_person_first_name_from_email
    build_owner
    owner.first_name, owner.last_name = email.split("@").first.split(/[._-]/).map(&:capitalize)
    owner.save
    self.owner_id = owner.id
  end
end
