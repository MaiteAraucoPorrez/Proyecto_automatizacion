require 'fileutils'

# ---------------------------------------------------------------------------
# Hooks a nivel de EJECUCION (no vistos en clase): BeforeAll / AfterAll
# ---------------------------------------------------------------------------
BeforeAll do
  FileUtils.mkdir_p('reports/screenshots')
  FileUtils.mkdir_p('reports/evidence')
  $suite_started_at = Time.now
  puts "== Inicio de la ejecucion: #{$suite_started_at.strftime('%H:%M:%S')} =="
end

AfterAll do
  puts "== Fin de la ejecucion. Duracion: #{(Time.now - $suite_started_at).round(1)} s =="
end

# ---------------------------------------------------------------------------
# Hooks a nivel de ESCENARIO (Before / After, vistos en clase)
# ---------------------------------------------------------------------------
Before do |scenario|
  @scenario_slug = scenario.name.gsub(/[^\w]+/, '_')[0, 50]
  @step_number   = 0
  Capybara.current_session.driver.browser.manage.window.maximize unless ENV['HEADLESS'] == 'true'
end

# Captura si fallo y cierra el navegador (como en los ejemplos del docente).
# Chrome arranca limpio en cada escenario, asi el carrito de SauceDemo (localStorage) no se arrastra.
# Cerrar el navegador tambien evita el reset interno de Capybara, que falla con Chrome reciente
# ("invalid argument: * is not a valid URL").
After do |scenario|
  if scenario.failed?
    begin
      path = "reports/screenshots/#{@scenario_slug}_#{Time.now.strftime('%H%M%S')}.png"
      page.save_screenshot(path)
      puts "Captura guardada: #{path}"
    rescue StandardError => e
      warn "No se pudo guardar la captura: #{e.message}"
    end
  end
  Capybara.current_session.driver.quit
  # Descarta la sesion para que el siguiente escenario cree un driver con 'options' nuevas.
  # Reusar el mismo objeto 'options' hace que Selenium duplique las barras '\' de la ruta
  # de chrome.exe en cada relanzamiento (Windows) hasta que la ruta deja de ser valida.
  Capybara.send(:session_pool).clear
end

# ---------------------------------------------------------------------------
# Hook a nivel de PASO (no visto en clase): AfterStep
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
