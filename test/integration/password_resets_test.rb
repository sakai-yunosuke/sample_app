# frozen_string_literal: true

require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base::deliveries.clear
    @user = users(:michael)
  end

  test 'password reset' do
    # Test for sending email form
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Invalid email address
    post password_resets_path, params: { password_reset: { email: '' } }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Valid email address
    post password_resets_path, params: {
      password_reset: {
        email: @user.email
      }
    }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # Test for password reset form
    user = assigns(:user)

    # Invalid email address
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url

    # Inactivated user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # Valid email, invalid token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # Valid email, token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    # Invalid password, password_confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'foobaz',
        password_confirmation: 'fooooo'
      }
    }
    assert_select 'div#error_explanation'

    # Empty password
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: '',
        password_confirmation: ''
      }
    }
    assert_select 'div#error_explanation'

    # Valid password, password_confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'foobar',
        password_confirmation: 'foobar'
      }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
