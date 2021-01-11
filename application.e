note
	description: "json_data_handler application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization
	menu: MENU

	make
	do
		io.put_string ("Tarea Programada 3 - Lenguajes de Programacion%N")
		io.put_string ("Andres Esteban Aguilar Moya - 2019156214%N")
		-- Iniciar menu
		create menu.iniciar_menu
	end

end
