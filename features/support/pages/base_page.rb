# Clase base de todos los Page Objects: da acceso al DSL de Capybara
class BasePage
  include Capybara::DSL

  CART_LINK = '.shopping_cart_link'.freeze
  CART_BADGE = '.shopping_cart_badge'.freeze

  def open_cart
    find(CART_LINK).click
  end

  def cart_count
    has_css?(CART_BADGE) ? find(CART_BADGE).text.to_i : 0
  end

  def cart_badge_displayed?
    has_css?(CART_BADGE)
  end
end
