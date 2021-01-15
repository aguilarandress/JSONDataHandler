note
	description: "Clase para leer y escribir archivos"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_MANAGER

create
	set_file_name

feature -- Set file name
	file_name: STRING

	set_file_name (name: STRING)
	do
		file_name := name
	end

	read_file: ARRAYED_LIST[STRING]
		-- Lee un archivo y lo almacena en un arreglo
	local
		file_lines: ARRAYED_LIST[STRING]
		entrada: PLAIN_TEXT_FILE
	do
		-- TODO: Verificar si el archivo existe
		-- Initialize list
		create file_lines.make (0)
		-- Crear handle para el archivo
		create entrada.make_open_read (file_name)
		if not entrada.access_exists then
			print("El archivo no existe%N")
		else
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
		end
		Result := file_lines
	end

feature -- Escribir archivo
	write_file (file_lines: ARRAYED_LIST[STRING])
		-- Escribe un archivo nuevo
	local
		salida: PLAIN_TEXT_FILE
		i: INTEGER
	do
		create salida.make_open_write (file_name)
		-- Escribir archivo
		from
			i := 1
		until
			i > file_lines.count
		loop
			salida.put_string (file_lines.at(i))
			if i /= file_lines.count then
				salida.new_line
			end
			i := i + 1
		end
		salida.close
	end

end
