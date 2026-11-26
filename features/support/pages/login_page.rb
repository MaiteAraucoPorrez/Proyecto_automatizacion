class LoginPage < BasePage
  USERNAME_FIELD = '#user-name'.freeze
  PASSWORD_FIELD = '#password'.freeze
  LOGIN_BUTTON   = '#login-button'.freeze
  ERROR_MESSAGE  = '[data-test="error"]'.freeze

  def load
    visit '/'
  end

  def displayed?
    has_css?(LOGIN_BUTTON)
  end

  def login_as(username, password)
    fill_in 'user-name', with: username
    fill_in 'password', with: password
    click_button 'login-button'
  end

  def error_text
    find(ERROR_MESSAGE).text
  end
end
