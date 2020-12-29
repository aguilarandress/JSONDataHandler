note
	description: "Clase para manipulacion de entrada y salida del menu de la aplicacion"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU

create
	iniciar_menu

feature {APPLICATION} 	-- Iniciar menu de la aplicacion
	iniciar_menu
	do
		print("Ingrese un comando: ")
		io.read_line
		print(io.last_string)
	end

end
