extends Control
class_name Article

signal activate
signal deactivate

#			Vars
@export var permission :FlowHandler.Permission:
	set(value):
		permission = value
		title.permission = permission
		body.permission = permission
		footer.permission = permission
		author.permission = permission
	get():
		return permission

var is_active :bool = false

@onready var title :Text = $title
@onready var body :Text = $body
@onready var footer :Text = $footer
@onready var image :TextureRect = $image
@onready var author :Text = $author


#			Funcs
func display() -> void:
	print('\n\t\t{0}\n\t{1}\n\n{3}\n{4}\n\n\tby {5}\n'.format([self, title.text, body.text, footer.text, author.text]))

func clear() -> void:
	title.clear()
	body.clear()
	footer.clear()
	image = null
	author.clear()
func copy(from :Article) -> void:
	title.copy(from.title)
	body.copy(from.body)
	footer.copy(from.footer)
	image = from.image.duplicate()
	author.copy(from.author)

func get_object(object :String) -> Variant:
	match object:
		"title": return title
		"body": return body
		"footer": return footer
		"image": return image
		"author": return author
		_: printerr('\n{ ', object, ' does not exist... }\n')
	return null
func set_object(object :String, value :Variant) -> void:
	match object:
		"title": title = value
		"body": body = value
		"footer": footer = value
		"image": image = value
		"author": author = value
		_: printerr('\n{ ', object, ' does not exist... }\n')
func remove_object(object :String) -> Variant:
	var value = null
	match object:
		"title":
			value = title
			title.clear()
		"body":
			value = body
			body.clear()
		"footer":
			value = footer
			footer.clear()
		"image":
			value = image
			image = null
		"author":
			value = author
			author.clear()
		_: printerr('\n{ ', object, ' does not exist... }\n')
	return value

func is_empty() -> bool:
	return title.is_empty() and body.is_empty() and footer.is_empty() and image == null


#			Signals
func _on_activate() -> void:
	is_active = true
func _on_deactivate() -> void:
	is_active = false

