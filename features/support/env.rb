require 'rspec/expectations'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'selenium-webdriver'

# --- AUT: SauceDemo -------------------------------------------------------
# Usuarios de prueba publicados en la pagina de login de SauceDemo
ENV['STANDARD_USER'] ||= 'standard_user'
ENV['LOCKED_USER']   ||= 'locked_out_user'
ENV['PSW']           ||= 'secret_sauce'

Capybara.run_server = false
Capybara.app_host = ENV['CAPYBARA_HOST'] || 'https://www.saucedemo.com'
Capybara.default_max_wait_time = 10

# --- Driver Chrome --------------------------------------------------------
Capybara.register_driver :chrome_testing do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--disable-notifications')
  options.add_argument('--window-size=1366,900')
  # Chrome muestra un popup de "cambia tu contrasena" con las credenciales de prueba
  options.add_argument('--disable-features=PasswordLeakDetection,PasswordManagerOnboarding')
  options.add_preference('credentials_enable_service', false)
  options.add_preference('profile.password_manager_enabled', false)
  options.add_preference('profile.password_manager_leak_detection', false)
  options.add_argument('--headless=new') if ENV['HEADLESS'] == 'true'

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara::Screenshot.register_driver(:chrome_testing) do |driver, path|
  driver.browser.save_screenshot(path)
end
Capybara::Screenshot.autosave_on_failure = false  # las capturas se guardan en hooks.rb
Capybara::Screenshot.append_timestamp = true
Capybara.save_path = 'reports/screenshots'

Capybara.default_driver = :chrome_testing
Capybara.javascript_driver = :chrome_testing

# --- Page Objects ---------------------------------------------------------
require_relative 'test_data'
require_relative 'pages/base_page'
Dir[File.join(__dir__, 'pages', '*.rb')].sort.each { |f| require f }
require_relative 'world_pages'
World(WorldPages)
