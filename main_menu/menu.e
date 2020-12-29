note
	description: "Clase para manipulacion de entrada y salida del menu de la aplicacion"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU

create
	iniciar_menu

feature {NONE} -- Leer linea ingresada por el usuario
	leer_linea : LIST[STRING]
	do
		io.read_line
		Result := io.last_string.split (' ')
	end

feature {APPLICATION} -- Iniciar menu de la aplicacion
	iniciar_menu
	local
		linea_ingresada: LIST[STRING]
	do
		print ("**Ingrese un comando**%N")
		from
			-- Iniciar leyendo lineas
			print("> ")
			linea_ingresada := leer_linea
		until
			linea_ingresada.first.is_equal("exit")
		loop
			-- Revisar comando
			if linea_ingresada.first.is_equal ("load") then
				print("Cargando archivo...")
			else
				print(linea_ingresada.first + "%N")
			end
			-- Continuar leyendo entrada por el usuario
			print("> ")
			linea_ingresada := leer_linea
		end
	end

end
