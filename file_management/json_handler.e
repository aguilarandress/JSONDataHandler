note
	description: "Summary description for {JSON_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_HANDLER

create
	set_estructuras

feature -- Access
	estructuras: ARRAYED_LIST[JSON_OBJECT]

	set_estructuras
	do
		create estructuras.make(0)
	end

feature -- Crear objetos JSON a partir de informacion CSV
	crear_objetos (csv_structure: ARRAYED_LIST[LIST[STRING]]): JSON_ARRAY
	local
		nombre_atributos: LIST[STRING]
		tipos_de_datos: LIST[STRING]
		estructuras_json: JSON_ARRAY
		i: INTEGER
	do
		-- Obtener nombre de los atributos y tipos
		nombre_atributos := csv_structure.at(1)
		tipos_de_datos := csv_structure.at(2)
		-- Eliminar las primeras dos filas
		-- Crear objetos json para cada fila
		create estructuras_json.make_empty
		from
			i := 3
		until
			i > csv_structure.count
		loop
			-- Crear objeto y agregarlo al JSON ARRAY
			estructuras_json.add(crear_objeto(nombre_atributos, tipos_de_datos, csv_structure.at(i)))
			i := i + 1
		end
		Result := estructuras_json
	end

	crear_objeto (nombre_atributos:LIST[STRING] tipo_datos:LIST[STRING] atributos: LIST[STRING]): JSON_OBJECT
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

	-- Crea un JSON_STRING a partir de un string
	crear_string (valor: STRING): JSON_STRING
	local
		new_string: JSON_STRING
	do
		create new_string.make_from_string (valor)
		Result := new_string
	end

	-- Crea un JSON_NUMBER a partir de un string
	crear_number (valor: STRING): JSON_NUMBER
	local
		new_number: JSON_NUMBER
	do
		create new_number.make_real(valor.to_real)
		Result := new_number
	end

	-- Crea un JSON_BOOLEAN a partir de un char
	crear_boolean (valor: STRING): JSON_BOOLEAN
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
