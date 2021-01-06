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
		print ("**Ingrese un comando**xd%N")
		from
			-- Iniciar leyendo lineas
			print("> ")
			linea_ingresada := leer_linea
		until

			linea_ingresada.first.is_equal("exit")
		loop
			-- Revisar comando
			if linea_ingresada.first.is_equal ("load") then
				load_csv_file (linea_ingresada.at (2), linea_ingresada.at (3))
			elseif linea_ingresada.first.is_equal ("hash") then
				print("comando")
			else
				print(linea_ingresada.first + "%N")
			end
			-- Continuar leyendo entrada por el usuario
			print("> ")
			linea_ingresada := leer_linea
		end
	end

feature {NONE} -- Cargar archivo CSV
	load_csv_file (nombre_estructura: STRING file_name: STRING)
	local
		csv_handler: CSV_HANDLER
		json_handler: JSON_HANDLER
		csv_structure: ARRAYED_LIST[LIST[STRING]]
		json_result: JSON_ARRAY
	do
		-- Leer estructura CSV
		create csv_handler.set_file_name (file_name)
		csv_structure := csv_handler.read_file
		-- Crear estrucura JSON
		create json_handler.set_estructuras
		json_result := json_handler.crear_objetos (csv_structure)
		print(json_result.representation)
	end

end
