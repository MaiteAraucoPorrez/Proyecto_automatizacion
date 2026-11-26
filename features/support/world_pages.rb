# Expone los Page Objects y el estado del escenario a todos los steps
module WorldPages
  def login_page;     @login_page     ||= LoginPage.new;     end
  def inventory_page; @inventory_page ||= InventoryPage.new; end
  def cart_page;      @cart_page      ||= CartPage.new;      end
  def checkout_page;  @checkout_page  ||= CheckoutPage.new;  end

  # Productos que el escenario ha agregado al carrito (para calcular totales esperados)
  def selected_products
    @selected_products ||= []
  end
end
