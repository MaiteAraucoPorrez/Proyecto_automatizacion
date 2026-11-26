require 'bigdecimal'

# Datos de prueba definidos por nosotros (NO se leen de la UI).
# Asi, si la aplicacion mostrara un precio incorrecto, la prueba lo detecta.
module TestData
  PRODUCTS = {
    'Sauce Labs Backpack'              => '29.99',
    'Sauce Labs Bike Light'            => '9.99',
    'Sauce Labs Bolt T-Shirt'          => '15.99',
    'Sauce Labs Fleece Jacket'         => '49.99',
    'Sauce Labs Onesie'                => '7.99',
    'Test.allTheThings() T-Shirt (Red)' => '15.99'
  }.freeze

  TAX_RATE = BigDecimal('0.08')

  def self.price(name)
    BigDecimal(PRODUCTS.fetch(name) { raise ArgumentError, "Producto sin precio definido: #{name}" })
  end

  def self.money(value)
    format('%.2f', value)
  end

  # Subtotal, impuesto y total esperados para una lista de productos
  def self.expected_summary(names)
    subtotal = names.sum(BigDecimal('0')) { |n| price(n) }
    tax      = (subtotal * TAX_RATE).round(2)
    { subtotal: money(subtotal), tax: money(tax), total: money(subtotal + tax) }
  end

  def self.sorted_names(option)
    case option
    when 'Name (A to Z)' then PRODUCTS.keys.sort
    when 'Name (Z to A)' then PRODUCTS.keys.sort.reverse
    else raise ArgumentError, "Orden por nombre desconocido: #{option}"
    end
  end

  # Precios esperados (como texto) al ordenar por precio
  def self.sorted_prices(option)
    prices = PRODUCTS.keys.map { |n| price(n) }.sort
    prices = prices.reverse if option == 'Price (high to low)'
    prices.map { |p| "$#{money(p)}" }
  end
end
