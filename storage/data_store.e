note
	description: "Permite almacenar y extraer datos en formato JSON"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	DATA_STORE

create
	make

feature -- Access
	json_store: HASH_TABLE[ARRAYED_LIST[JSON_OBJECT], STRING]
	data_type_store: HASH_TABLE[detachable LIST[STRING], STRING]

	make
	do
		create json_store.make(0)
		create data_type_store.make(0)
	end

feature -- Insertar nueva estructura JSON
	add_json_arr (nombre: STRING new_arr: ARRAYED_LIST[JSON_OBJECT])
		-- Inserta un nuevo JSON_ARRAY con un nombre
	do
		-- Verificar que no exista en el store
		if not json_store.has (nombre) then
			json_store.put (new_arr, nombre)
		end
	end

	add_data_types (nombre: STRING data_types: detachable LIST[STRING])
		-- Inserta los tipos de datos para una estructura JSON
	do
		-- Verificar que no exista en el store
		if not data_type_store.has(nombre) then
			data_type_store.put (data_types, nombre)
		end
	end

feature -- Proyecta los tipos de datos de la estructura `nombre_original`
	project_data_types (nombre: STRING nombre_original: STRING atributos: ARRAYED_LIST[STRING])
		-- Proyecta los tipos de datos
	local
		data_types: LIST[STRING]
		result_str: STRING
		json_arr_original: ARRAYED_LIST[JSON_OBJECT]
		json_obj: JSON_OBJECT
		json_keys: ARRAY[JSON_STRING]
		i: INTEGER
		attr_index: INTEGER
		j: INTEGER
	do
		result_str := ""
		data_types := data_type_store.at (nombre_original)
		-- Obtener jsons originales
		json_arr_original := json_store.item(nombre_original)
		if data_types /= Void and json_arr_original /= Void then
			-- Obtener llaves
			json_obj := json_arr_original.at (1)
			json_keys := json_obj.current_keys
			-- Buscar atributos
			from
				i := 1
			until
				i > atributos.count
			loop
				from
					j := 1
				until
					j > json_keys.count
				loop
					-- Obtener indice del atributo
					if json_keys.at(j).is_equal (create {JSON_STRING}.make_from_string(atributos.at(i))) then
						attr_index := j
					end
					j := j + 1
				end
				-- Agregar tipo de dato
				result_str.append(data_types.at(attr_index))
				if i /= atributos.count then
					result_str.extend(';')
				end
				i := i + 1
			end
			data_type_store.put (result_str.split(';'), nombre)
		end
	end

end
