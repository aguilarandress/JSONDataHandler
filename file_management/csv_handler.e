note
	description: "Clase para manejo de archivos CSV"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	CSV_HANDLER

create
	set_file_name

feature -- File name
	file_name: STRING

	set_file_name (new_file_name: STRING)
	do
		file_name := new_file_name
	end

feature -- Read CSV file
	read_file
	local
		file_manager: FILE_MANAGER
		csv_rows: ARRAYED_LIST[LIST[STRING]]
		current_row: LIST[STRING]
		file_lines: ARRAYED_LIST[STRING]
	do
		-- Leer lineas del archivo
		create file_manager.set_file_name(file_name)
		file_lines := file_manager.read_file
		-- Obtener columnas para cada fila
		create csv_rows.make (0)
		across file_lines as line loop
			current_row := line.item.split (';')
			print("Fila: ")
			across current_row as column loop
				print(column)
			end
			csv_rows.extend (current_row)
		end
	end

end
