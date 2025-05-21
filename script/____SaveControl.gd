extends Node

#			Vars
enum Sphere {global, doc}

const PATH_CONFIG_GLOBAL := "res://Setting.ini"
const PATH_CONFIG_DOC := "res://Documents.ini"

var config_global := ConfigFile.new()
var config_doc := ConfigFile.new()


#			Funcs
func _ready() -> void:
	if FileAccess.file_exists(PATH_CONFIG_GLOBAL):
		config_global.load(PATH_CONFIG_GLOBAL)
	else:
		config_global.set_value("Setting", "Graphic", RenderingServer.VIEWPORT_MSAA_DISABLED)
		config_global.set_value("Setting", "Audio", AudioServer.get_bus_volume_linear(0))
		config_global.set_value("Setting", "Control", 0)
		config_global.save(PATH_CONFIG_GLOBAL)
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

func load_config(sphere :Sphere, section :String, key :String = '') -> Variant:
	var file
	match sphere:
		Sphere.global: file = config_global
		Sphere.doc: file = config_doc
	if key.is_empty():
		var info = {}
		for k in file.get_section_keys(section):
			info[k] = file.get_value(section, k)
		return info
	else:
		return file.get_value(section, key)
func save_config(sphere :Sphere, section :String, key :String, value :Variant) -> void:
	var file
	match sphere:
		Sphere.global: file = config_global
		Sphere.doc: file = config_doc
	file.set_value(section, key, value)
	match sphere:
		Sphere.global: file.save(PATH_CONFIG_GLOBAL)
		Sphere.doc: file.save(PATH_CONFIG_DOC)

func load_resource_doc(resource_path :String) -> DocumentResource:
	if FileAccess.file_exists(resource_path): return load(resource_path) as DocumentResource
	else: return null
func save_resource_doc(resource_doc :DocumentResource) -> void:
	var resource = DocumentResource.new()
	resource.copy(resource_doc)
	if not resource.resource_path: resource.resource_path = "res://Resource/Article_{0}.tres".format([resource.title])
	ResourceSaver.save(resource, resource.resource_path)

