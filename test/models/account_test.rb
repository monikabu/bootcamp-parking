require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test 'it should belong to person' do
    @account = accounts(:one)
    assert_equal('Anakin', @account.owner.first_name)
  end

  test 'it should create person object (and try to guess name) when saving' do
    @account = Account.create(email: 'jan.kowalski@gmail.com', password: 'password', password_confirmation: 'password')
    @person = Person.find_by(first_name: 'Jan')
    assert_equal(@person, @account.owner)
  end

  test 'it should be invalid without email' do
    invalid_account = Account.new(email: nil, password: 'password', password_confirmation: 'password')
    assert_equal(false, invalid_account.errors.has_key?(:email))
  end

  test 'it should be invalid without password on create' do
    invalid_account = Account.create(email: 'magda_mucha@wp.pl', password: nil)
    assert_equal(false, invalid_account.valid?)
  end

  test 'it should be valid without password after create' do
    account = Account.create(email: 'magda_mucha@wp.pl', password: 'password', password_confirmation: 'password')
    account.password = nil
    assert_equal(true, account.valid?)
  end

  test 'encrypted password should be created when setting password' do
    @account = Account.create(email: 'magda_mucha@wp.pl', password: 'password', password_confirmation: 'password')
    assert_not_nil(@account.encrypted_password)
  end

  test 'it should be invalid with wrong password confirmation' do
    account = Account.create(email: 'magda_mucha@wp.pl', password: 'password', password_confirmation: 'password1')
    assert_equal(false, account.valid?)
  end

  test 'password comparation should return false when account does not have encrypted password at all' do
    account = Account.create(email: 'magda_mucha@wp.pl', password: 'password', password_confirmation: 'password')
    account.encrypted_password = nil
    assert_equal(false, account.valid_password?('password'))
  end

  test 'password comparation should return false when password is different' do
    account = Account.create(email: 'magda_mucha@wp.pl', password: 'password', password_confirmation: 'password1')
    assert_equal(false, account.valid_password?('password'))
  end

  test 'password comparation should return true when password is the same' do
    account = Account.create(email: 'magda_mucha@wp.pl', password: 'password', password_confirmation: 'password')
    assert_equal(true, account.valid_password?('password'))
  end

  test 'Account.authenticate should return account object if email and password are valid' do
    Account.create(email: 'magda_mucha@wp.pl', password: 'password', password_confirmation: 'password')
    authenticated_account = Account.authenticate('magda_mucha@wp.pl', 'password')
    assert_equal('magda_mucha@wp.pl', authenticated_account.email)
  end

  test 'Account.authenticate should return nil if password does not match' do
    Account.create(email: 'magda_mucha@wp.pl', password: 'password', password_confirmation: 'password')
    assert_nil(Account.authenticate('magda_mucha@wp.pl', 'password1'))
  end

  test 'Account.authenticate should return nil if email can not be found' do
    assert_nil(Account.authenticate('magda_mucha@wp.pl', 'password'))
  end

  test 'Account.authenticate! should raise exception if authentication can not be done' do
    assert_raises(Account::NotAuthorized) {Account.authenticate!('magda_mucha@wp.pl', 'password')}
  end
end

