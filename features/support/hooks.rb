require 'fileutils'

# ===========================================================================
# HOOKS (como en clase: se definen por nivel -> escenario, paso y etiqueta)
# ===========================================================================

# ---------------------------------------------------------------------------
# Hooks de EJECUCION completa (no vistos en clase): BeforeAll / AfterAll
# ---------------------------------------------------------------------------
BeforeAll do
  FileUtils.mkdir_p('reports/screenshots')
  FileUtils.mkdir_p('reports/evidence')
  $suite_started_at = Time.now
  $scenario_count   = 0
  $scenario_results = Hash.new(0)
  puts "== Inicio de la ejecucion: #{$suite_started_at.strftime('%H:%M:%S')} =="
end

AfterAll do
  total = $scenario_results.values.sum
  resumen = $scenario_results.map { |estado, n| "#{estado}: #{n}" }.join(' | ')
  puts "== Fin de la ejecucion. #{total} escenarios (#{resumen}) en #{(Time.now - $suite_started_at).round(1)} s =="
  puts "== Capturas por escenario en reports/screenshots =="
end

# ---------------------------------------------------------------------------
# Hook con ETIQUETA (visto en clase: Before '@maximize')
# Los features que llevan @maximize abren Chrome maximizado.
# ---------------------------------------------------------------------------
Before('@maximize') do
  Capybara.current_session.driver.browser.manage.window.maximize unless ENV['HEADLESS'] == 'true'
end

# ---------------------------------------------------------------------------
# Hooks de ESCENARIO (Before / After, vistos en clase)
# ---------------------------------------------------------------------------
Before do |scenario|
  @scenario_started_at = Time.now
  @step_number         = 0
  @scenario_slug       = scenario.name.gsub(/[^\w]+/, '_')[0, 50]
end

# After corre SIEMPRE, aunque el escenario falle o se omita.
# 1) Captura de pantalla de CADA escenario (nombre + estado + hora) y la adjunta al reporte HTML.
# 2) Muestra el estado y el tiempo del escenario en consola.
# 3) Cierra el navegador (como en los ejemplos del docente). Chrome arranca limpio en cada escenario,
#    asi el carrito de SauceDemo (localStorage) no se arrastra entre escenarios.
After do |scenario|
  estado = scenario.status.to_s.upcase # PASSED / FAILED / SKIPPED ...
  $scenario_count   += 1
  $scenario_results[estado] += 1

  begin
    nombre = format('%03d_%s_%s_%s.png', $scenario_count, @scenario_slug, estado, Time.now.strftime('%H%M%S'))
    ruta   = File.join('reports', 'screenshots', nombre)
    page.save_screenshot(ruta)
    attach(ruta, 'image/png') # aparece dentro del reporte HTML
  rescue StandardError => e
    warn "No se pudo guardar la captura: #{e.message}"
  end

  puts "   [#{estado}] #{scenario.name} - #{(Time.now - @scenario_started_at).round(1)} s"

  Capybara.current_session.driver.quit
  # Descarta la sesion para que el siguiente escenario cree un driver con 'options' nuevas.
  # (Reusar el mismo objeto 'options' hace que Selenium duplique las barras '\' de la ruta de
  # chrome.exe en cada relanzamiento en Windows, hasta que la ruta deja de ser valida.)
  Capybara.send(:session_pool).clear
end

# ---------------------------------------------------------------------------
# Hook de PASO (visto en clase: "step hooks"): AfterStep
# Con EVIDENCE=true guarda una captura despues de cada paso (evidencias para el board).
# Uso: bundle exec cucumber -p evidence
# ---------------------------------------------------------------------------
AfterStep do
  @step_number += 1
  next unless ENV['EVIDENCE'] == 'true'

  begin
    page.save_screenshot("reports/evidence/#{@scenario_slug}_paso#{format('%02d', @step_number)}.png")
  rescue StandardError => e
    warn "No se pudo guardar la evidencia: #{e.message}"
  end
end
