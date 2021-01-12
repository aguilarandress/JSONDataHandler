note
	description: "Clase de utilidad para manipular y transformar valores de tipo STRING."
	author: "Andres Aguilar"
	date: "$Date$"
	revision: "$Revision$"

class
	STRING_UTILITIES

create
	set_string,
	initialize_string

feature -- Create
	string: STRING

	set_string(new_str: STRING)
	do
		string := new_str
	end

	initialize_string
	do
		string := ""
	end

feature -- Eliminar primer y ultimo caracter
	remove_first_and_last
		-- Elimina el primer y ultimo caracter del string
	require
		min_length: string.count >= 3
	local
		i: INTEGER
		result_str: STRING
	do
		result_str := ""
		from
			i := 2
		until
			i = string.count
		loop
			result_str.extend (string.at(i))
			i := i + 1
		end
		string := result_str
	end

end
