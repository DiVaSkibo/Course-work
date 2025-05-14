extends Node

#			Vars
const PATH_CONFIG_DOC := "res://Documents.ini"
const PATH_RESOURCE := "res://Resource/{0}.tres"

var config_doc := ConfigFile.new()


#			Funcs
func _ready() -> void:
	if FileAccess.file_exists(PATH_CONFIG_DOC):
		config_doc.load(PATH_CONFIG_DOC)
	else:
		config_doc.set_value("Table", "Reports", [])
		config_doc.set_value("Table", "Articles", [])
		config_doc.set_value("Locker", "Reports", [])
		config_doc.set_value("Locker", "Articles", [])
		config_doc.set_value("Locker-double", "Reports", [])
		config_doc.set_value("Locker-double", "Articles", [])
		config_doc.save(PATH_CONFIG_DOC)

func load_config_doc(section :String, key :String = '') -> Variant:
	if key.is_empty():
		var info = {}
		for k in config_doc.get_section_keys(section):
			info[k] = config_doc.get_value(section, k)
		return info
	else:
		return config_doc.get_value(section, key)
func save_config_doc(section :String, key :String, value :Variant) -> void:
	config_doc.set_value(section, key, value)
	config_doc.save(PATH_CONFIG_DOC)

func load_resource_doc(resource_name :String) -> DocumentResource:
	print(PATH_RESOURCE.format([resource_name]))
	return load(PATH_RESOURCE.format([resource_name])) as DocumentResource
func save_resource_doc(resource_doc :DocumentResource) -> void:
	var resource = DocumentResource.new()
	resource.copy(resource_doc)
	print(PATH_RESOURCE.format([resource.resource_name]))
	ResourceSaver.save(resource, PATH_RESOURCE.format([resource.resource_name]))

