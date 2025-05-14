extends Node

#			Vars
const PATH_DOC := "res://Documents.ini"

var config_doc := ConfigFile.new()


#			Funcs
func _ready() -> void:
	if FileAccess.file_exists(PATH_DOC):
		config_doc.load(PATH_DOC)
	else:
		config_doc.set_value("Table", "Report", [])
		config_doc.set_value("Table", "Article", [])
		config_doc.set_value("Locker", "Report", [])
		config_doc.set_value("Locker", "Article", [])
		config_doc.set_value("Locker-double", "Report", [])
		config_doc.set_value("Locker-double", "Article", [])
		config_doc.save(PATH_DOC)

func load_doc(section :String, key :String = '') -> Variant:
	if key.is_empty():
		var info = {}
		for k in config_doc.get_section_keys(section):
			info[k] = config_doc.get_value(section, k)
		return info
	else:
		return config_doc.get_value(section, key)
func save_doc(section :String, key :String, value :Variant) -> void:
	config_doc.set_value(section, key, value)
	config_doc.save(PATH_DOC)

