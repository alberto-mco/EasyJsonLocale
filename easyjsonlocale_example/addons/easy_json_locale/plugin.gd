@tool
extends EditorPlugin

var _easy_json_locale_plugin:EasyJsonLocale = null

#=======================================================================
#Enter tree
#=======================================================================
func _enter_tree()->void:
	var l_resource:Resource = preload("easy_json_locale.gd")
	
	#Creamos una nueva instancia del plugin
	_easy_json_locale_plugin = l_resource.new()
	
	#Insertamos el plugin
	add_import_plugin(_easy_json_locale_plugin)

#=======================================================================
#Exit tree
#=======================================================================
func _exit_tree()->void:
	#Eliminamos el plugin
	remove_import_plugin(_easy_json_locale_plugin)
	
	#Apuntamos a null
	_easy_json_locale_plugin = null
