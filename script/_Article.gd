extends Control
class_name Article

signal activate
signal deactivate

#			Vars
enum Error {none, Empty, Size}

const MAX_HEADER :int = 5
const MAX_BODY :int = 30
const MAX_FOOTER :int = 20

@export var permission :FlowHandler.Permission:
	set(value):
		permission = value
		header.permission = permission
		body.permission = permission
		footer.permission = permission
	get():
		return permission

var is_active :bool = false

@onready var header :Text = $header
@onready var body :Text = $body
@onready var footer :Text = $footer
@onready var image :TextureRect = $image


#			Funcs
func display() -> void:
	print('\n\t\t{0}\n\t{1}\n\n{3}\n{4}\n'.format([self, header.text, body.text, footer.text]))

func clear() -> void:
	header.clear()
	image = null
	body.clear()
	footer.clear()
func copy(from :Article) -> void:
	header.copy(from.header)
	image = from.image.duplicate()
	body.copy(from.body)
	footer.copy(from.footer)

func get_object(object :String) -> Variant:
	match object:
		"header": return header
		"image": return image
		"body": return body
		"footer": return footer
		_: printerr('\n{ ', object, ' does not exist... }\n')
	return null
func set_object(object :String, value :Variant) -> void:
	match object:
		"header": header = value
		"image": image = value
		"body": body = value
		"footer": footer = value
		_: printerr('\n{ ', object, ' does not exist... }\n')
func remove_object(object :String) -> Variant:
	var value = null
	match object:
		"header":
			value = header
			header.clear()
		"image":
			value = image
			image = null
		"body":
			value = body
			body.clear()
		"footer":
			value = footer
			footer.clear()
		_: printerr('\n{ ', object, ' does not exist... }\n')
	return value

func is_empty() -> bool:
	return header.is_empty() and body.is_empty() and footer.is_empty() and image == null

func analyze() -> Array:
	if header.atext.size() <= 0 or header.atext.size() >= MAX_HEADER: return [Error.Size, "header"]
	if body.atext.size() <= 0 or body.atext.size() >= MAX_HEADER: return [Error.Size, "body"]
	if footer.atext.size() <= 0 or footer.atext.size() >= MAX_HEADER: return [Error.Size, "footer"]
	if image == null: return [Error.Empty, "image"]
	return [Error.none, ""]


#			Signals
func _on_activate() -> void:
	is_active = true
func _on_deactivate() -> void:
	is_active = false

