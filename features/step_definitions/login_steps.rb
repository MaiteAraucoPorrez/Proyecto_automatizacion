When('I log in with user {string} and password {string}') do |user, password|
  login_page.login_as(user, password)
end

Then('I should see the products page') do
  expect(inventory_page).to be_displayed
end

Then('I should see the error {string}') do |message|
  expect(login_page.error_text).to eq(message)
end

Then('the error message contains {string}') do |text|
  expect(login_page.error_text).to include(text)
end

When('I log out') do
  inventory_page.logout
end

Then('I should be back on the login page') do
  expect(login_page).to be_displayed
end
