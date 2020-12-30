note
	description: "Clase para leer y escribir archivos"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_MANAGER

create
	set_file_name

feature {CSV_HANDLER} -- Set file name
	file_name: STRING

	set_file_name (name: STRING)
	do
		file_name := name
	end

feature {CSV_HANDLER} -- Leer archivo de entrada
	read_file: ARRAYED_LIST[STRING]
	local
		file_lines: ARRAYED_LIST[STRING]
		entrada: PLAIN_TEXT_FILE
	do
		-- TODO: Verificar si el archivo existe
		-- Initialize list
		create file_lines.make (0)
		-- Crear handle para el archivo
		create entrada.make_open_read (file_name)
		-- Iniciar lectura
		from
			entrada.read_line
		until
			entrada.exhausted
		loop
			-- Agregar linea actual al array
			file_lines.extend (entrada.last_string.twin)
			entrada.read_line
		end
		-- Leer linea del final
		file_lines.extend (entrada.last_string.twin)
		entrada.close
		Result := file_lines
	end
	
end
