# Automatización de Smoke Test - SauceDemo

![Estado](https://img.shields.io/badge/estado-en%20desarrollo-yellow)
![BDD](https://img.shields.io/badge/BDD-Cucumber-brightgreen)
![Ruby](https://img.shields.io/badge/Ruby-3.x-red)

Proyecto del **Automation Sprint** de la materia SIS-312 Gestión de Calidad de Sistemas (trabajo individual).

## Índice
1. [Descripción del proyecto](#descripción-del-proyecto)
2. [Estado del proyecto](#estado-del-proyecto)
3. [Funcionalidades automatizadas](#funcionalidades-automatizadas)
4. [Acceso al proyecto](#acceso-al-proyecto)
5. [Estructura de carpetas](#estructura-de-carpetas)
6. [Tecnologías utilizadas](#tecnologías-utilizadas)

## Descripción del proyecto
Framework de pruebas automatizadas con enfoque **BDD** para ejecutar un **Smoke Test** sobre la AUT
[SauceDemo](https://www.saucedemo.com/), una tienda en línea de ejemplo. Los escenarios se escriben en
Gherkin y se automatizan con Cucumber, Capybara y Selenium (Chrome), usando el patrón Page Object.

Todos los escenarios forman el **Smoke Test**: cubren el flujo crítico de compra del sitio. Cada feature lleva una
etiqueta de área (`@login`, `@carrito`, `@checkout`, `@logout`, `@catalogo`) y el defecto conocido va con `@bug`.

## Estado del proyecto
En desarrollo (sprint del 24 de noviembre al 2 de diciembre). Los features se agregan de forma incremental.

| Feature | Estado |
|---|---|
| Login | Listo |

## Funcionalidades automatizadas
**Login** (`features/1login.feature`)
- Login exitoso con usuario estándar.
- Login con usuario bloqueado.
- Credenciales inválidas, con `Scenario Outline` de 4 ejemplos .
- Acceso directo a la página de productos sin iniciar sesión .

## Acceso al proyecto
1. Clonar el repositorio.
2. Instalar Ruby 3+ y Google Chrome, y luego las dependencias: `bundle install`
3. Ejecutar las pruebas:

| Comando | Qué hace |
|---|---|
| `bundle exec cucumber` | Todo el Smoke Test (excluye `@bug`) |
| `bundle exec cucumber features/1login.feature` | Un solo feature |
| `bundle exec cucumber -p smoke` | Smoke Test completo con reporte HTML |
| `bundle exec cucumber -t @login` | Solo un área (por etiqueta) |
| `bundle exec cucumber -p headless` | Sin abrir la ventana de Chrome |

4. Revisar los resultados en la consola o en el reporte HTML. Cada escenario guarda una captura de pantalla en
   `reports/screenshots` (nombre, estado y hora) y la adjunta al reporte.
   El perfil `smoke` genera el reporte en `reports/`
   (por ejemplo, `reports/smoke_report.html`). También se puede generar con:
   `bundle exec cucumber features --format html --out reports/reporte.html`

> Windows con idioma español: si aparece `invalid byte sequence in UTF-8`, ejecutar una vez
> `ruby patch_cucumber_windows.rb`.

## Estructura de carpetas
```
features/
├── 1login.feature            Escenarios en Gherkin
├── step_definitions/         Pasos genéricos y reutilizables
└── support/
    ├── env.rb                Configuración de Capybara y Chrome
    ├── hooks.rb              Hooks (Before, After, BeforeAll, AfterAll, AfterStep)
    ├── test_data.rb          Datos de prueba
    ├── world_pages.rb        Acceso a los Page Objects desde los pasos
    └── pages/                Page Objects
reports/                      Reportes generados (los .html no se versionan)
cucumber.yml                  Perfiles de ejecución
Gemfile                       Dependencias
```

## Tecnologías utilizadas
Ruby, Cucumber, Gherkin, Capybara, Selenium WebDriver, RSpec y Chrome.
