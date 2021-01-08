note
	description: "Summary description for {ARRAY_UTILS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARRAY_UTILS

create
	set_str_array

feature -- Crea un string a partir de un separador
	str_array: ARRAY[STRING]

	set_str_array (new_str_array: ARRAY[STRING])
		-- Asigna el nuevo `str_array`
	do
		str_array := new_str_array
	end

	join_strs(separador: STRING): STRING
		-- Genera un nuevo string a partir de un arreglo de strings
	local
		result_str: STRING
		i: INTEGER
	do
		result_str := ""
		from
			i := 0
		until
			i > str_array.count
		loop
			result_str.append(str_array.at(i))
			if i /= str_array.count then
				result_str.extend(';')
			else
			end
			i := i + 1
		end
		Result := result_str
	end

end
