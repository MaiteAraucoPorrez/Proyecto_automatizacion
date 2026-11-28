When('I add the product {string} to the cart') do |product|
  inventory_page.add_to_cart(product)
  selected_products << product
end

# Varios productos separados por ";"
When('I add the products {string} to the cart') do |products|
  products.split(';').map(&:strip).each do |product|
    inventory_page.add_to_cart(product)
    selected_products << product
  end
end

# Sirve tanto en la pagina de productos como en el carrito
When('I remove the product {string} from the cart') do |product|
  find('.inventory_item, .cart_item', text: product).click_button('Remove')
  selected_products.delete(product)
end

Then('the cart badge shows {int} item(s)') do |count|
  expect(inventory_page.cart_count).to eq(count)
end

Then('the cart badge is not displayed') do
  expect(inventory_page).not_to be_cart_badge_displayed
end

Then('the cart contains the following products:') do |table|
  expect(cart_page).to be_displayed
  expect(cart_page.product_names).to match_array(table.raw.flatten)
end

# El precio esperado viene de TestData, no de la UI
Then('the cart shows the product {string} with the price defined for it') do |product|
  expect(cart_page).to be_displayed
  expect(cart_page.product_price(product)).to eq("$#{TestData::PRODUCTS.fetch(product)}")
end
