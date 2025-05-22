extends Node

#			Vars
enum Sphere {global, doc}

const PATH_CONFIG_GLOBAL := "res://Setting.ini"
const PATH_CONFIG_DOC := "res://Documents.ini"
const RESOURCES := {
	 "res://Resource/Report_Abyros.tres": preload("res://Resource/Report_Abyros.tres"),
	 "res://Resource/Report_Cryvolis.tres": preload("res://Resource/Report_Cryvolis.tres"),
	 "res://Resource/Report_Cyrathis.tres": preload("res://Resource/Report_Cyrathis.tres"),
	 "res://Resource/Report_Elyndra.tres": preload("res://Resource/Report_Elyndra.tres"),
	 "res://Resource/Report_Ignarok.tres": preload("res://Resource/Report_Ignarok.tres"),
	 "res://Resource/Report_Noxthesia.tres": preload("res://Resource/Report_Noxthetia.tres"),
	 "res://Resource/Report_Nyxar.tres": preload("res://Resource/Report_Nyxar.tres"),
	 "res://Resource/Report_Scaeryn.tres": preload("res://Resource/Report_Scaeryn.tres"),
	 "res://Resource/Report_Sylvaris.tres": preload("res://Resource/Report_Sylvaris.tres"),
	 "res://Resource/Report_Velcrith.tres": preload("res://Resource/Report_Velcrith.tres"),
	 "res://Resource/Report_Virellune.tres": preload("res://Resource/Report_Virellune.tres"),
	 "res://Resource/Report_Zarynth.tres": preload("res://Resource/Report_Zarynth.tres"),
	 "res://Resource/Report_Zyphora.tres": preload("res://Resource/Report_Zyphora.tres"),
}

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
	var config
	match sphere:
		Sphere.global: config = config_global
		Sphere.doc: config = config_doc
	if key.is_empty():
		var info = {}
		for k in config.get_section_keys(section):
			info[k] = config.get_value(section, k)
		return info
	else: return config.get_value(section, key)
func save_config(sphere :Sphere, section :String, key :String, value :Variant) -> void:
	var config
	match sphere:
		Sphere.global: config = config_global
		Sphere.doc: config = config_doc
	config.set_value(section, key, value)
	match sphere:
		Sphere.global: config.save(PATH_CONFIG_GLOBAL)
		Sphere.doc: config.save(PATH_CONFIG_DOC)

func load_resource_doc(resource_path :String) -> DocumentResource:
	if RESOURCES.has(resource_path): return RESOURCES[resource_path] as DocumentResource
	else: return null
func save_resource_doc(resource_doc :DocumentResource) -> void:
	var resource = DocumentResource.new()
	resource.copy(resource_doc)
	if resource_doc.resource_path: ResourceSaver.save(resource, resource_doc.resource_path)
	else: ResourceSaver.save(resource_doc, "res://Resource/Article_{0}.tres".format([resource_doc.title]))

