note
	description: "Clase para manejo de archivos CSV"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CSV_HANDLER

create
	set_file_name

feature -- File name
	file_name: STRING

	set_file_name (new_file_name: STRING)
	do
		file_name := new_file_name
	end

end
