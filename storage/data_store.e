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
	json_store: HASH_TABLE[JSON_ARRAY, STRING]
	attr_info: HASH_TABLE[ARRAYED_LIST[STRING], STRING]

	make
	do
		create json_store.make(0)
		create attr_info.make(0)
	end

feature -- Insertar nuevo arreglo JSON
	add_json_arr (nombre: STRING new_arr: JSON_ARRAY): BOOLEAN
		-- Inserta un nuevo JSON_ARRAY con un nombre
	do
		-- Verificar que no exista en el store
		if not json_store.has (nombre) then
			json_store.put (new_arr, nombre)
			Result := true
		else
			Result := false
		end
	end

end
