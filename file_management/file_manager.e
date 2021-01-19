note
	description: "Clase para leer y escribir archivos"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_MANAGER

create
	set_file_name

feature -- Initialization
	file_name: STRING

	set_file_name (name: STRING)
	do
		file_name := name
	end

feature -- Verifica si el archivo existe
	check_file_exists: BOOLEAN
		-- Determina si el archivo existe en el file system
	local
		file_test: PLAIN_TEXT_FILE
		file_path: PATH
	do
		create file_path.make_from_string (file_name)
		create file_test.make_with_path (file_path.absolute_path)
		if file_test.exists and then file_test.is_readable then
			Result := true
		else
			Result := false
		end
	end

feature -- Leer el archivo `file_name`
	read_file: ARRAYED_LIST[STRING]
		-- Lee un archivo y lo almacena en un arreglo
	local
		file_lines: ARRAYED_LIST[STRING]
		entrada: PLAIN_TEXT_FILE
	do
		-- Initialize list
		create file_lines.make (0)
		if not check_file_exists then
			print("El archivo no existe...%N")
		else
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
