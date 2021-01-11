note
	description: "Clase para manipulacion de entrada y salida del menu de la aplicacion"
	author: "Andres Aguilar"
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
	data_store: DATA_STORE

	iniciar_menu
	local
		linea_ingresada: LIST[STRING]
		obj: JSON_OBJECT
	do
		-- Inicializar data store
		create data_store.make
		print ("**Ingrese un comando**%N")
		from
			-- Iniciar leyendo lineas
			print("> ")
			linea_ingresada := leer_linea
		until
			linea_ingresada.first.is_equal("exit")
		loop
			-- Revisar comando
			-- Comando load [nombre_estructura] [path]
			if linea_ingresada.first.is_equal ("load") then
				load_csv_file (linea_ingresada.at (2), linea_ingresada.at (3))
			-- Comando save [nombre_estructura] [path]
			elseif linea_ingresada.first.is_equal ("save") then
				save_json_file(linea_ingresada.at(2), linea_ingresada.at(3))
			-- Comando savecsv [nombre_estructura] [path]
			elseif linea_ingresada.first.is_equal ("savecsv") then
				save_csv_file(linea_ingresada.at(2), linea_ingresada.at(3))
			else
				print("Comando desconocido...%N")
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
	do
		-- Leer estructura CSV
		create csv_handler.set_file_name (file_name)
		csv_structure := csv_handler.read_file
		-- Crear estrucura JSON
		create json_handler.initialize_arr
		json_handler.crear_objetos(csv_structure)
		-- Guardar en data store
		if data_store.add_json_arr(nombre_estructura, json_handler.json_arr) then
			print("Estructura " + nombre_estructura + " almacenada...%N")
		else
			print("Ya existe esta estructura...")
		end
	end

feature {NONE} -- Crea un archivo JSON con los datos
	save_json_file (nombre_json: STRING path: STRING)
		-- Almacena la estructura `nombre_json` en un archivo JSON
	local
		json_handler: JSON_HANDLER
		json_arr: JSON_ARRAY
	do
		if not data_store.json_store.has (nombre_json) then
			print("La estructura " + nombre_json + " no se encuentra almacenada...")
		else
			-- Obtener datos del store
			json_arr := data_store.json_store.at(nombre_json)
			if json_arr /= Void then
				create json_handler.set_json_arr(json_arr)
				json_handler.save_json(path)
			end
			print("Archivo JSON generado...")
		end
	end

feature {NONE} -- Crea un archivo CSV con los datos de la estructura
	save_csv_file (nombre_json: STRING path: STRING)
		-- Almacena la estructura `nombre_json` en un archivo CSV
	local
		json_arr: JSON_ARRAY
		csv_handler: CSV_HANDLER
	do
		-- Verificar si la estructura existe
		if not data_store.json_store.has (nombre_json) then
			print("La estructura " + nombre_json + " no se encuentra almacenada...")
		else
			-- Obtener datos del store
			json_arr := data_store.json_store.at(nombre_json)
			-- TODO: Llamar funcion del CSV_HANDLER
			create csv_handler.set_file_name(path)
			--csv_handler.write_estructura_json(json_arr)
			print("Archivo JSON generado...")
		end
	end

end
