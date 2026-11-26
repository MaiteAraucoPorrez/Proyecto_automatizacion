# Pasos compartidos por varios features

Given('I am on the SauceDemo login page') do
  login_page.load
  expect(login_page).to be_displayed
end

Given('I am logged in as a standard user') do
  login_page.load
  login_page.login_as(ENV['STANDARD_USER'], ENV['PSW'])
  expect(inventory_page).to be_displayed
end

# Paso generico: abre cualquier ruta del sitio directamente
When('I open the page {string} directly') do |path|
  visit path
end

# Paso generico: abre el carrito desde cualquier pagina
When('I open the cart') do
  inventory_page.open_cart
end
