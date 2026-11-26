class InventoryPage < BasePage
  TITLE        = '[data-test="title"]'.freeze
  ITEM         = '.inventory_item'.freeze
  ITEM_NAME    = '.inventory_item_name'.freeze
  ITEM_PRICE   = '.inventory_item_price'.freeze
  SORT         = '[data-test="product-sort-container"]'.freeze
  MENU_BUTTON  = '#react-burger-menu-btn'.freeze
  LOGOUT_LINK  = '#logout_sidebar_link'.freeze

  def displayed?
    has_css?(TITLE, text: 'Products')
  end

  def add_to_cart(product_name)
    find(ITEM, text: product_name).click_button('Add to cart')
  end

  # Hash { "Nombre" => "$precio" } con lo que muestra la UI
  def products
    all(ITEM).each_with_object({}) do |item, hash|
      hash[item.find(ITEM_NAME).text] = item.find(ITEM_PRICE).text
    end
  end

  # Listas en el orden en que se muestran en pantalla
  def product_names
    all(ITEM).map { |item| item.find(ITEM_NAME).text }
  end

  def product_prices
    all(ITEM).map { |item| item.find(ITEM_PRICE).text }
  end

  def sort_by(option_text)
    find(SORT).select(option_text)
  end

  def logout
    find(MENU_BUTTON).click
    find(LOGOUT_LINK).click
  end
end
