note
	description: "Clase de utilidades para estructuras de datos de colecciones"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	COLLECTION_UTILITIES

create
	set_list

feature -- Crea un string a partir de una lista con `separador`

	list: LIST[STRING]

	set_list(new_list: LIST[STRING])
	do
		list := new_list
	end

	join_list(separador: CHARACTER): STRING
		-- Crea un string a partir de una lista con `separador`
	local
		result_str: STRING
		i: INTEGER
	do
		result_str := ""
		from
			i := 1
		until
			i > list.count
		loop
			result_str.append (list.at(i))
			if i /= list.count then
				result_str.extend(';')
			end
			i := i + 1
		end
		Result := result_str
	end

end
