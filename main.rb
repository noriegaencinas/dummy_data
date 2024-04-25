require 'tk'
require 'json'
require 'csv'

def fecha_aleatoria
  year = rand(1900..2000)
  month = rand(1..12)
  day = rand(1..31)

  if month == 2
    if (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0)
      day = rand(1..29)
    else
      day = rand(1..28)
    end
  elsif [4, 6, 9, 11].include?(month)
    day = rand(1..30)
  end

  "#{year}-#{month}-#{day}"
end

# Define las listas de apellidos y nombres
apellidos = {
  "Alemán" => ["Müller", "Schmidt", "Schneider", "Fischer", "Meyer", "Weber", "Schulz", "Wagner", "Becker", "Hoffmann"],
  "Portugués" => ["Silva", "Santos", "Ferreira", "Pereira", "Oliveira", "Costa", "Rodrigues", "Martins", "Fernandes", "Gomes"],
  "Mexicano" => ["Hernández", "González", "López", "Martínez", "Pérez", "García", "Sánchez", "Ramírez", "Torres", "Flores"]
}
nombres_mexicanos = ["José", "María", "Juan", "Guadalupe", "Ana", "Francisco", "Luis", "Margarita", "Pedro", "Alejandra"]


# Obtener el ancho y alto de la pantalla
window_width = 300
window_height = 150

# Crear la ventana principal
root = TkRoot.new do
  title "DummyData"
  geometry '300x150'  # Establecer el tamaño de la ventana
  positionfrom 'user'  # Centrar la ventana en la pantalla
end

# Obtener el ancho y alto de la pantalla
screen_width = root.winfo_screenwidth
screen_height = root.winfo_screenheight

# Calcular las coordenadas para centrar la ventana
x = (screen_width - window_width) / 2  # Centrar horizontalmente
y = (screen_height - window_height) / 2  # Centrar verticalmente

# Mover la ventana a las coordenadas calculadas
root.geometry("+#{x}+#{y}")

# Función para crear un espacio entre elementos
def create_space(parent)
  TkFrame.new(parent) {
    height 5
    pack(fill: 'both', padx: 10, pady: 0, side: 'top')
  }
end

# Crear el label
label = TkLabel.new(root) do
  text "Introduce la cantidad de registros a crear:"
  pack { padx 10 ; pady 10; side 'top' }  # Ajustar el empaquetado
end

create_space(root)

# Crear el textfield
textfield = TkEntry.new(root) do
  width 10
  pack { padx 10 ; pady 10; side 'top' }  # Ajustar el empaquetado
end

create_space(root)

# Crear el combobox para seleccionar el tipo de apellido
combobox = Tk::Tile::Combobox.new(root) do
  values apellidos.keys
  pack { padx 10 ; pady 10; side 'top' }  # Ajustar el empaquetado
  state 'readonly'
end

create_space(root)

# Inicializar el contador
$contador = 0

# Crear el botón
button = TkButton.new(root) do
  text "Aceptar"
  command proc {
    # Obtener el tipo de apellido seleccionado
    tipo_apellido = combobox.get

    # Guardar en formato JSON
    File.open("registros.json", "w") do |json_file|
      registros = []
      textfield.value.to_i.times do
        matricula = 200000000 + $contador
        apellido1 = apellidos[tipo_apellido].sample
        apellido2 = apellidos[tipo_apellido].sample
        nombre = nombres_mexicanos.sample
        correo = "#{matricula}@example.com"
        fecha_nacimiento = fecha_aleatoria

        registros << {
          matricula: matricula,
          apellido1: apellido1,
          apellido2: apellido2,
          nombres: nombre,
          correo: correo,
          fecha_nacimiento: fecha_nacimiento
        }

        $contador += 1
      end
      json_file.puts JSON.pretty_generate(registros)
    end

    # Guardar en formato CSV
    CSV.open("registros.csv", "w") do |csv|
      csv << ["Matricula", "Apellido 1", "Apellido 2", "Nombres", "Correo", "Fecha de Nacimiento"]
      textfield.value.to_i.times do
        matricula = 200000000 + $contador
        apellido1 = apellidos[tipo_apellido].sample
        apellido2 = apellidos[tipo_apellido].sample
        nombre = nombres_mexicanos.sample
        correo = "#{matricula}@example.com"
        fecha_nacimiento = fecha_aleatoria

        csv << [matricula, apellido1, apellido2, nombre, correo, fecha_nacimiento]

        $contador += 1
      end
    end

    # Guardar en formato SQL
    sql_data = "INSERT INTO registros (matricula, apellido1, apellido2, nombres, correo, fecha_nacimiento) VALUES"
    textfield.value.to_i.times do
      matricula = 200000000 + $contador
      apellido1 = apellidos[tipo_apellido].sample
      apellido2 = apellidos[tipo_apellido].sample
      nombre = nombres_mexicanos.sample
      correo = "#{matricula}@example.com"
      fecha_nacimiento = fecha_aleatoria

      sql_data += "\n('#{matricula}', '#{apellido1}', '#{apellido2}', '#{nombre}', '#{correo}', '#{fecha_nacimiento}'),"

      $contador += 1
    end
    # Eliminar la última coma
    sql_data = sql_data.chomp(',')
    sql_data += ';'

    File.open("registros.sql", "w") do |sql_file|
      sql_file.puts sql_data
    end

    # Guardar en formato XML
    xml_data = '<?xml version="1.0" encoding="UTF-8"?>'
    xml_data += '<registros>'
    textfield.value.to_i.times do
      matricula = 200000000 + $contador
      apellido1 = apellidos[tipo_apellido].sample
      apellido2 = apellidos[tipo_apellido].sample
      nombre = nombres_mexicanos.sample
      correo = "#{matricula}@example.com"
      fecha_nacimiento = fecha_aleatoria

      xml_data += "<registro>"
      xml_data += "<matricula>#{matricula}</matricula>"
      xml_data += "<apellido1>#{apellido1}</apellido1>"
      xml_data += "<apellido2>#{apellido2}</apellido2>"
      xml_data += "<nombres>#{nombre}</nombres>"
      xml_data += "<correo>#{correo}</correo>"
      xml_data += "<fecha_nacimiento>#{fecha_nacimiento}</fecha_nacimiento>"
      xml_data += "</registro>"

      $contador += 1
    end
    xml_data += '</registros>'

    File.open("registros.xml", "w") do |xml_file|
      xml_file.puts xml_data
    end
  }
  pack { padx 10 ; pady 15; side 'top' }  # Ajustar el empaquetado
end

# Iniciar el bucle de eventos
Tk.mainloop
