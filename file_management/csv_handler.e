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
			create utils
			file_lines.extend(utils.join_list(data_types, ';'))
			-- Agregar valores de cada objeto
			across json_arr as object loop
				file_lines.extend(get_value_string(object.item))
			end
			file_manager.write_file (file_lines)
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

	get_value_string (json_obj: JSON_OBJECT): STRING
		-- Genera un string para valores del `json_obj`
	local
		i: INTEGER
		current_val: JSON_VALUE
		result_str: STRING
	do
		result_str := ""
		from
			i := 1
		until
			i > json_obj.current_keys.count
		loop
			current_val := json_obj.item(json_obj.current_keys.at(i))
			-- Append value
			if current_val /= Void then
				result_str.append(get_csv_representation(current_val.representation))
				-- Agregar separador
				if i /= json_obj.current_keys.count then
					result_str.extend(';')
				end
			end
			i := i + 1
		end
		Result := result_str
	end

	get_csv_representation (json_val: STRING): STRING
		-- Obtiene la representacion CSV de los valores de cada objeto
	local
		result_str: STRING
		str_utils: STRING_UTILITIES
	do
		-- Check if null
		if json_val.is_equal ("null") then
			result_str := ""
		-- Check if string
		elseif json_val.at(1).is_equal('"') then
			-- Eliminar double quotes
			create str_utils.set_string(json_val)
			str_utils.remove_first_and_last
			result_str := str_utils.string
		-- Check if true
		elseif json_val.is_equal("true") then
			result_str := "S"
		-- Check if false
		elseif json_val.is_equal("false") then
			result_str := "N"
		-- No transformation needed
		else
			result_str := json_val
		end
		Result := result_str
	end
end
