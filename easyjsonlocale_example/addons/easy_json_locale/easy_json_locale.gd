@tool
extends EditorImportPlugin

class_name EasyJsonLocale

#=======================================================================
#Obtiene el nombre único del importador
#=======================================================================
func _get_importer_name()->String:
	return "json_locale_importer"

#=======================================================================
#Obtiene el nombre que se mostrará en la ventana de importación
#=======================================================================
func _get_visible_name()->String:
	return "Easy Json locale"

#=======================================================================
#Obtiene la lista de extensiones de archivo a asociar con este cargador (sin distinguir entre mayúsculas y minúsculas)
#=======================================================================
func _get_recognized_extensions()->PackedStringArray:
	return ["json"]

#=======================================================================
#Obtiene la extensión utilizada para guardar este recurso en el directorio ".godot/imported"
#=======================================================================
func _get_save_extension()->String:
	return "translation"

#=======================================================================
#Obtiene el tipo de recurso Godot asociado con este plugin
#=======================================================================
func _get_resource_type()->String:
	return "Translation"

#=======================================================================
#Obtiene el número de ajustes preestablecidos iniciales definidos por el plugin
#=======================================================================
func _get_preset_count()->int:
	return 1

#=======================================================================
#Obtiene el nombre de las opciones preestablecidas en este índice
#=======================================================================
func _get_preset_name(_preset:int)->String:
	return "Default"

#=======================================================================
#Obtiene las opciones y los valores predeterminados del valor preestablecido en este índice.
#Devuelve una matriz de diccionarios con las siguientes claves: name, default_value, property_hint(opcional), hint_string(opcional), usage(opcional)
#=======================================================================
func _get_import_options(_path:String, _preset_index:int):
	return []

#=======================================================================
#Obtiene el orden de ejecución de este importador al importar recursos
#=======================================================================
func _get_import_order()->int:
	return 0

#=======================================================================
#Obtiene la prioridad de este plugin para la extensión reconocida. Se priorizarán los plugins con mayor prioridad. La prioridad predeterminada es 1.0
#=======================================================================
func _get_priority()->float:
	return 1.0

#=======================================================================
#Importa con la importación especificada
#=======================================================================
func _import(p_source_file:String, p_save_path:String, p_options:Dictionary, _platform_variants:Array[String], p_gen_files:Array[String])->Error:
	var l_result:Error = Error.FAILED
	var l_json_text = FileAccess.get_file_as_string(p_source_file)
	var l_json_obj:JSON = JSON.new()
	
	#Parseamos el fichero json
	l_json_obj.parse(l_json_text)
	
	#Comprobamos que el documento sea un diccionario
	if (typeof(l_json_obj.data) == Variant.Type.TYPE_DICTIONARY):
		var l_translations:Dictionary[String, Translation] = {}
		var l_root_groups:Dictionary = l_json_obj.data
		
		#Recorremos todas las traducciones
		for l_root_group_key:String in l_root_groups.keys():
			#Comprobamos si es un dictionary, ya que indica que es un grupo de traducciones
			if (typeof(l_root_groups[l_root_group_key]) == Variant.Type.TYPE_DICTIONARY):
				var l_root_group_content:Dictionary = l_root_groups[l_root_group_key]
				
				#Importamos el grupo
				_import_group(l_translations, "", l_root_group_key, l_root_group_content)
		
		#Establecemos el resultado de la operación
		l_result = Error.OK
		
		#Recorremos todas las traducciones
		for l_translation_locale:String in l_translations.keys():
			var l_filename:String = "%s.%s.%s" % [p_source_file.get_basename(), l_translation_locale, _get_save_extension()]
			
			#Guardamos el recurso
			if (ResourceSaver.save(l_translations[l_translation_locale], l_filename) != Error.OK):
				#Marcamos el resultado de la operación como fallida
				l_result = Error.FAILED
			else:
				#Guardamos el fichero que se ha generado
				p_gen_files.append(l_filename)
	
	#Godot espera un fichero en la ruta indicada p_save_path, así que lo creamos con un resource de Translation vacío (dummy file)
	ResourceSaver.save(Translation.new(), "%s.%s" % [p_save_path, _get_save_extension()])
	
	return l_result

#=======================================================================
#Importa un grupo de traducciones
#=======================================================================
func _import_group(p_available_translations:Dictionary[String, Translation], p_prefix:String, p_group_key:String, p_group_content:Dictionary)->void:
	#Recorremos todas las entradas del grupo
	for l_content_key:String in p_group_content.keys():
		#Comprobamos si es un string, ya que indica que es una traduccion
		if (typeof(p_group_content[l_content_key]) == Variant.Type.TYPE_STRING):
			#Importamos la traducción
			_import_translation(p_available_translations, l_content_key, "%s%s" % [p_prefix, p_group_key], p_group_content[l_content_key])
		#Comprobamos si es un dictionary, ya que indica que es un grupo de traducciones
		elif (typeof(p_group_content[l_content_key]) == Variant.Type.TYPE_DICTIONARY):
			#Importamos el subgrupo
			_import_group(p_available_translations, "%s%s%s" % [p_prefix, p_group_key, "_"], l_content_key, p_group_content[l_content_key])

#=======================================================================
#Importa una traducción
#=======================================================================
func _import_translation(p_available_translations:Dictionary[String, Translation], p_locale:String, p_key:String, p_message_translated:String)->void:
	#Comprobamos si aún no había ningún Translation creado
	if (p_available_translations.has(p_locale) == false):
		#Creamos una nueva instancia del objeto Translation
		p_available_translations[p_locale] = Translation.new()
		
		#Establecemos la localización de la traducción
		p_available_translations[p_locale].locale = p_locale
	
	#Insertamos la traducción
	p_available_translations[p_locale].add_message(p_key, p_message_translated)
