extends Node

#			Vars
const PATH_CONFIG_DOC := "res://Documents.ini"

var config_doc := ConfigFile.new()


#			Funcs
func _ready() -> void:
	if FileAccess.file_exists(PATH_CONFIG_DOC):
		config_doc.load(PATH_CONFIG_DOC)
	else:
		config_doc.set_value("Table", "Report", [])
		config_doc.set_value("Table", "Article", [])
		config_doc.set_value("Locker", "Report", [])
		config_doc.set_value("Locker", "Article", [])
		config_doc.set_value("Locker-double", "Report", [])
		config_doc.set_value("Locker-double", "Article", [])
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

func load_resource_doc(resource_path :String) -> DocumentResource:
	return load(resource_path) as DocumentResource
func save_resource_doc(resource_doc :DocumentResource) -> void:
	var resource = DocumentResource.new()
	resource.copy(resource_doc)
	ResourceSaver.save(resource, resource.resource_path)

