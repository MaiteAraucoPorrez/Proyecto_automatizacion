# Parche local para Cucumber 12 en Windows con idioma espanol.
# Problema: unicode.rb ejecuta `cmd /c chcp` y la respuesta ("Pagina de codigos activa...")
# no es UTF-8 valido, lo que lanza "invalid byte sequence in UTF-8".
# Solucion: tratar esa salida como bytes (.b) antes de aplicar la expresion regular.
#
# Uso (una sola vez):  ruby patch_cucumber_windows.rb
spec = Gem::Specification.find_by_name('cucumber')
file = File.join(spec.gem_dir, 'lib', 'cucumber', 'formatter', 'unicode.rb')
needle = '`cmd /c chcp`'
src = File.binread(file)

if src.include?("#{needle}.b")
  puts "Ya estaba parcheado: #{file}"
elsif src.include?(needle)
  File.binwrite(file, src.sub(needle, "#{needle}.b"))
  puts "Parcheado: #{file}"
else
  abort "No se encontro la linea esperada en #{file}"
end
