note
	description: "Permite la manipulacion de datos y estructuras JSON"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_HANDLER

create
	set_json_arr

feature -- Access
	json_arr: JSON_ARRAY

	set_json_arr
	do
		create json_arr.make_empty
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
			json_arr.add(crear_objeto(nombre_atributos, tipos_de_datos, csv_structure.at(i)))
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
		-- Revisar el tipo de dato
		inspect tipo_dato.at (1).item.as_upper
		when 'X' then
			new_value := crear_string (valor)
		when 'N' then
			new_value := crear_number (valor)
		else
			new_value := crear_boolean (valor)
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
	do
		create new_number.make_real(valor.to_real)
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
