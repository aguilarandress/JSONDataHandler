note
	description: "Permite la manipulacion de datos y estructuras JSON"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_HANDLER

create
	set_json_arr,
	initialize_arr

feature -- Access
	json_arr: ARRAYED_LIST[JSON_OBJECT]

	set_json_arr (new_arr: ARRAYED_LIST[JSON_OBJECT])
		-- Asigna el nuevo array de JSON
	do
		json_arr := new_arr
	end

	initialize_arr
		-- Inicializa un array vacio
	do
		create json_arr.make(0)
	end

feature -- Escribe un archivos JSON con los datos
	save_json (path: STRING)
		-- Guarda un archivo JSON con los datos de json_objs
	local
		file_lines: ARRAYED_LIST[STRING]
		file_manager: FILE_MANAGER
		i: INTEGER
		current_line: STRING
		representation_utils: REPRESENTATION_UTILS
	do
		create file_lines.make (0)
		file_lines.extend ("[")
		create representation_utils.make
		-- Add string representations of objects
		from
			i := 1
		until
			i > json_arr.count
		loop
			-- Get object representation
			representation_utils.create_json_string(json_arr.at(i))
			if i /= json_arr.count then
				file_lines.extend(representation_utils.result_string + ",")
			else
				file_lines.extend(representation_utils.result_string)
			end
			i := i + 1
		end
		file_lines.extend ("]")
		-- Escribir archivo
		create file_manager.set_file_name (path)
		file_manager.write_file(file_lines)
	end

feature -- Obtener JSONs que cumplan con una condicion
	get_jsons_with_condition(atributo: STRING valor: STRING): ARRAYED_LIST[JSON_OBJECT]
		-- Obtiene JSONs que cumplan con una condicion dada
	local
		new_jsons: ARRAYED_LIST[JSON_OBJECT]
		str_utils: STRING_UTILITIES
		json_val: attached JSON_VALUE
		str_val: STRING
	do
		create new_jsons.make(0)
		create str_utils.initialize_string
		across json_arr as json_object loop
			-- Check if string to remove double quotes from representation
			json_val := json_object.item.item(create {JSON_STRING}.make_from_string (atributo))
			if json_val /= Void then
				if json_val.is_string then
					-- Remove double quotes
					str_utils.set_string(json_val.representation)
					str_utils.remove_first_and_last
					str_val := str_utils.string
				else
					str_val := json_val.representation
				end
				-- Check if object meets condition
				if str_val.is_equal(valor) then
					new_jsons.extend(json_object.item)
				end
			end
		end
		Result := new_jsons
	end

feature -- Proyectar jsons
	project_jsons(atributos: ARRAYED_LIST[STRING]): ARRAYED_LIST[JSON_OBJECT]
		-- Obtiene JSONs con los `atributos` especificados
	require
		min_arr_length: json_arr.count > 0
		min_attr_length: atributos.count > 0
	local
		result_arr: ARRAYED_LIST[JSON_OBJECT]
		i: INTEGER
	do
		create result_arr.make(0)
		from
			i := 1
		until
			i > json_arr.count
		loop
			-- Crear objeto con nuevo con atributos
			result_arr.extend(project_json_object(json_arr.at(i), atributos))
			i := i + 1
		end
		Result := result_arr
	end

	project_json_object (json_obj: JSON_OBJECT atributos: ARRAYED_LIST[STRING]): JSON_OBJECT
		-- Obtiene un objetos JSON con los `atributos` especificados
	require
		min_keys: json_obj.current_keys.count > 0
	local
		new_json_obj: JSON_OBJECT
		current_value: JSON_VALUE
		i: INTEGER
	do
		create new_json_obj.make_empty
		from
			i := 1
		until
			i > atributos.count
		loop
			-- Get value
			current_value := json_obj.item(create {JSON_STRING}.make_from_string(atributos.at(i)))
			-- Add to JSON object
			new_json_obj.put(current_value, atributos.at(i))
			i := i + 1
		end
		Result := new_json_obj
	end

feature -- Crear objetos JSON a partir de informacion CSV
	crear_objetos (csv_structure: ARRAYED_LIST[LIST[STRING]])
		-- Crea objetos JSON a partir de una estructura CSV
	local
		nombre_atributos: LIST[STRING]
		tipos_de_datos: LIST[STRING]
		i: INTEGER
	do
		-- Obtener nombre de los atributos y tipos
		nombre_atributos := csv_structure.at(1)
		tipos_de_datos := csv_structure.at(2)
		-- Crear objetos json para cada fila
		from
			i := 3
		until
			i > csv_structure.count
		loop
			-- Crear objeto y agregarlo al JSON ARRAY
			json_arr.extend(crear_objeto(nombre_atributos, tipos_de_datos, csv_structure.at(i)))
			i := i + 1
		end
	end

	crear_objeto (nombre_atributos:LIST[STRING] tipo_datos:LIST[STRING] atributos: LIST[STRING]): JSON_OBJECT
		-- Crea un objeto JSON nuevo
	local
		objeto_json: JSON_OBJECT
		i: INTEGER
	do
		create objeto_json.make_empty
		from
			i := 1
		until
			i > nombre_atributos.count
		loop
			objeto_json.put (convertir_atributo(atributos.at (i), tipo_datos.at (i)), create {JSON_STRING}.make_from_string (nombre_atributos.at(i)))
			i := i + 1
		end
		Result := objeto_json
	end

feature -- Convertir atributos a tipos de datos JSON
	convertir_atributo (valor: STRING tipo_dato: STRING): JSON_VALUE
		-- Convierte el tipo de un atributo a un JSON_VALUE
	local
		new_value: JSON_VALUE
	do
		-- Revisar si es null primero
		if valor.is_equal("") then
			new_value := create {JSON_NULL}
		else
			-- Revisar el tipo de dato
			inspect tipo_dato.at (1).item.as_upper
			when 'X' then
				new_value := crear_string (valor)
			when 'N' then
				new_value := crear_number (valor)
			else
				new_value := crear_boolean (valor)
			end
		end
		Result := new_value
	end

	crear_string (valor: STRING): JSON_STRING
		-- Crea un JSON_STRING a partir de un string
	local
		new_string: JSON_STRING
	do
		create new_string.make_from_string (valor)
		Result := new_string
	end

	crear_number (valor: STRING): JSON_NUMBER
		-- Crea un JSON_NUMBER a partir de un string
	local
		new_number: JSON_NUMBER
		str_utils: STRING_UTILITIES
	do
		-- Reemplazar , por el . en caso de tenerlo
		create str_utils.set_string(valor)
		str_utils.replace_char(',', '.')
		create new_number.make_real(str_utils.string.to_double)
		Result := new_number
	end

	crear_boolean (valor: STRING): JSON_BOOLEAN
		-- Crea un JSON_BOOLEAN a partir de un char
	local
		new_boolean: JSON_BOOLEAN
	do
		-- Revisar si es verdader
		if valor.is_equal ("T") or valor.is_equal ("S") then
			create new_boolean.make_true
		else
			create new_boolean.make_false
		end
		Result := new_boolean
	end

end
