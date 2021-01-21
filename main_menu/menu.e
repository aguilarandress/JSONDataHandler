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
		collection_utils: COLLECTION_UTILITIES
	do
		-- Inicializar data store
		create data_store.make
		create collection_utils
		print ("**Ingrese un comando**%N")
		from
			-- Iniciar leyendo lineas
			print(">> ")
			linea_ingresada := leer_linea
		until
			linea_ingresada.first.is_equal("exit")
		loop
			-- Revisar comando
			-- TODO: Revisar longitud de los comandos
			-- Comando load [nombre_estructura] [path]
			if linea_ingresada.first.is_equal ("load") then
				load_csv_file (linea_ingresada.at (2), linea_ingresada.at (3))
			-- Comando save [nombre_estructura] [path]
			elseif linea_ingresada.first.is_equal ("save") then
				save_json_file(linea_ingresada.at(2), linea_ingresada.at(3))
			-- Comando savecsv [nombre_estructura] [path]
			elseif linea_ingresada.first.is_equal ("savecsv") then
				save_csv_file(linea_ingresada.at(2), linea_ingresada.at(3))
			-- Comando select [nombre] [nombre_nuevo] [atributo] = [valor]
			elseif linea_ingresada.first.is_equal ("select") then
				select_jsons(linea_ingresada.at(2), linea_ingresada.at(3), linea_ingresada.at(4), collection_utils.sub_list(linea_ingresada, 6))
			elseif linea_ingresada.first.is_equal("project") then
				project_structure(linea_ingresada.at(2), linea_ingresada.at(3), collection_utils.sub_list(linea_ingresada, 4))
			else
				print("Comando desconocido...%N")
			end
			-- Continuar leyendo entrada por el usuario
			print(">> ")
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
		-- Verificar si ya existe la estructura
		if data_store.json_store.has(nombre_estructura) then
			print("Ya existe esta estructura...%N")
		else
			-- Leer estructura CSV
			create csv_handler.set_file_name (file_name)
			csv_structure := csv_handler.read_file
			if csv_structure.count > 0 then
				-- Save data types
				data_store.add_data_types(nombre_estructura, csv_structure.at(2))
				-- Crear estrucura JSON
				create json_handler.initialize_arr
				json_handler.crear_objetos(csv_structure)
				-- Guardar en data store
				data_store.add_json_arr(nombre_estructura, json_handler.json_arr)
				print("Estructura " + nombre_estructura + " almacenada...%N")
			end
		end
	end

feature {NONE} -- Crea un archivo JSON con los datos
	save_json_file (nombre_json: STRING path: STRING)
		-- Almacena la estructura `nombre_json` en un archivo JSON
	local
		json_handler: JSON_HANDLER
		json_arr: ARRAYED_LIST[JSON_OBJECT]
	do
		if not data_store.json_store.has (nombre_json) then
			print("La estructura " + nombre_json + " no se encuentra almacenada...%N")
		else
			-- Obtener datos del store
			json_arr := data_store.json_store.at(nombre_json)
			if json_arr /= Void then
				create json_handler.set_json_arr(json_arr)
				json_handler.save_json(path)
			end
			print("Archivo JSON generado...%N")
		end
	end

feature {NONE} -- Crea un archivo CSV con los datos de la estructura
	save_csv_file (nombre_json: STRING path: STRING)
		-- Almacena la estructura `nombre_json` en un archivo CSV
	local
		json_arr: ARRAYED_LIST[JSON_OBJECT]
		data_types: LIST[STRING]
		csv_handler: CSV_HANDLER
		collection_utils: COLLECTION_UTILITIES
	do
		-- Verificar si la estructura existe
		if not data_store.json_store.has(nombre_json) then
			print("La estructura " + nombre_json + " no se encuentra almacenada...%N")
		else
			-- Obtener datos del store
			json_arr := data_store.json_store.at(nombre_json)
			data_types := data_store.data_type_store.at(nombre_json)
			-- Escribir archivo
			create csv_handler.set_file_name(path)
			csv_handler.write_estructura_json(json_arr, data_types)
			print("Archivo CSV generado...%N")
		end
	end

feature {NONE} -- Seleccionar JSON que cumplan con una condicion
	select_jsons (nombre_json: STRING nombre_nuevo: STRING atributo: STRING valor: ARRAYED_LIST[STRING])
	local
		json_handler: JSON_HANDLER
		json_arr: ARRAYED_LIST[JSON_OBJECT]
		new_json_arr: ARRAYED_LIST[JSON_OBJECT]
		collection_utils: COLLECTION_UTILITIES
		data_types: LIST[STRING]
	do
		if not data_store.json_store.has(nombre_json) then
			print("La estructura " + nombre_json + " no se encuentra almacenada...%N")
		else
			-- Verificar que `nombre_nuevo` no exista en el `data_store`
			if data_store.json_store.has(nombre_nuevo) or data_store.data_type_store.has(nombre_nuevo) then
				print("Ya existe una estructura con ese nombre...%N")
			else
				json_arr := data_store.json_store.at(nombre_json)
				if json_arr /= Void then
					-- Obtener JSONS que cumplan con la condicion
					create json_handler.set_json_arr(json_arr)
					-- crear string separado por espacios
					create collection_utils
					new_json_arr := json_handler.get_jsons_with_condition(atributo, collection_utils.join_arrayed_list(valor, ' '))
					-- Si no se obtuvieron objetos, no se agregan
					if new_json_arr.count = 0 then
						print("Ningun objeto cumplio con la condicion...%N")
					else
						-- Guardar objetos
						data_store.add_json_arr(nombre_nuevo, new_json_arr)
						data_types := data_store.data_type_store.at(nombre_json)
						if data_types /= Void then
							data_store.add_data_types(nombre_nuevo, data_store.data_type_store.at(nombre_json))
						end
						print("Estructura " + nombre_nuevo + " creada...%N")
					end
				end
			end
		end
	end

feature {NONE} -- Proyecta una estructura con ciertos atributos
	project_structure (nombre_json: STRING nombre_nuevo: STRING atributos: ARRAYED_LIST[STRING])
		-- Proyecta la estructura `nombre_json` en `nombre_nuevo`
	local
		json_arr: ARRAYED_LIST[JSON_OBJECT]
		data_types: LIST[STRING]
		new_json_arr: ARRAYED_LIST[JSON_OBJECT]
		json_handler: JSON_HANDLER
	do
		-- Verificar que la estructura con `nombre_json` exista
		if not data_store.json_store.has(nombre_json) then
			print("La estructura " + nombre_json + " no se encuentra almacenada...%N")
		else
			-- Verificar que la estructura `nombre_nuevo` no exista
			if data_store.json_store.has(nombre_nuevo) then
				print("La estructura " + nombre_nuevo + " ya existe...%N")
			else
				-- Obtener estructura JSON
				json_arr := data_store.json_store.at(nombre_json)
				data_types := data_store.data_type_store.at(nombre_json)
				if json_arr /= Void and data_types /= Void then
					create json_handler.set_json_arr(json_arr)
					-- Proyectar jsons
					new_json_arr := json_handler.project_jsons(atributos)
					data_store.add_json_arr(nombre_nuevo, new_json_arr)
					-- Guardar tipos de datos
					data_store.project_data_types(nombre_nuevo, nombre_json, atributos)
					print("Estructura " + nombre_nuevo + " almacenada...%N")
				end
			end
		end
	end

end
