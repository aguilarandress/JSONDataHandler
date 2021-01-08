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
	read_file: ARRAYED_LIST[LIST[STRING]]
	local
		file_manager: FILE_MANAGER
		csv_rows: ARRAYED_LIST[LIST[STRING]]
		file_lines: ARRAYED_LIST[STRING]
	do
		-- Leer lineas del archivo
		create file_manager.set_file_name(file_name)
		file_lines := file_manager.read_file
		-- Obtener columnas para cada fila
		create csv_rows.make (0)
		across file_lines as line loop
			csv_rows.extend (line.item.split (';'))
		end
		Result := csv_rows
	end

feature -- Escribir archivo CSV con datos JSON
	write_estructura_json (json_arr: JSON_ARRAY path: STRING)
	local
		file_manager: FILE_MANAGER
		json_keys: ARRAY[STRING]
		arr_utils: ARRAY_UTILS
	do
		create file_manager.set_file_name (path)

	end

end
