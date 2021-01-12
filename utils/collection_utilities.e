note
	description: "Clase de utilidades para estructuras de datos de colecciones"
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	COLLECTION_UTILITIES

feature -- Crea un string a partir de una lista con `separador`
	join_list(list: LIST[STRING] separador: CHARACTER): STRING
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

	join_arrayed_list(arr: ARRAYED_LIST[STRING] separador: CHARACTER): STRING
		-- Crea un string a partir de un ARRAYED_LIST con un `separador`
	local
		result_str: STRING
		i: INTEGER
	do
		result_str := ""
		from
			i := 1
		until
			i > arr.count
		loop
			result_str.append (arr.at(i))
			if i /= arr.count then
				result_str.extend(separador)
			end
			i := i + 1
		end
		Result := result_str
	end


end
