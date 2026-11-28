class CartPage < BasePage
  TITLE      = '[data-test="title"]'.freeze
  ITEM       = '.cart_item'.freeze
  ITEM_NAME  = '.inventory_item_name'.freeze
  ITEM_PRICE = '.inventory_item_price'.freeze
  CHECKOUT   = '#checkout'.freeze

  def displayed?
    has_css?(TITLE, text: 'Your Cart')
  end

  def product_names
    all(ITEM).map { |item| item.find(ITEM_NAME).text }
  end

  def product_price(name)
    find(ITEM, text: name).find(ITEM_PRICE).text
  end

  def checkout
    find(CHECKOUT).click
  end
end
