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
		if not json_store.has (nombre) then
			data_type_store.put (data_types, nombre)
		end
	end

end
