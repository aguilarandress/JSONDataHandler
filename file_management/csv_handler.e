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
	write_estructura_json (json_arr: detachable ARRAYED_LIST[JSON_OBJECT] data_types: detachable LIST[STRING])
		-- Escribe la estructura de `json_arr` en un archivo con formato CSV
	local
		file_manager: FILE_MANAGER
		utils: COLLECTION_UTILITIES
		file_lines: ARRAYED_LIST[STRING]
	do
		create file_manager.set_file_name (file_name)
		create file_lines.make(0)
		-- Obtener string de atributos
		if json_arr /= Void and data_types /= Void then
			-- Escribir atributos
			file_lines.extend(get_attr_string(json_arr.at(1).current_keys))
			-- Escribir tipos de datos
			create utils.set_list(data_types)
			file_lines.extend(utils.join_list(';'))
			file_manager.write_file (file_lines)
			-- TODO: Obtener valores de cada fila
		end
	end

	get_attr_string (attr_array: ARRAY[JSON_STRING]): STRING
		-- Crea el string de atributos separados por ;
	local
		attr_string: STRING
		i: INTEGER
	do
		attr_string := ""
		from
			i := 1
		until
			i > attr_array.count
		loop
			-- Agregar nombre del atributo actual
			attr_string.append(attr_array.item(i).item)
			-- Agregar ';' en medio de cada atributo
			if i /= attr_array.count then
				attr_string.extend(';')
			end
			i := i + 1
		end
		Result := attr_string
	end
end
