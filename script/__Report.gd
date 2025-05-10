extends Control
class_name Report

signal activate
signal deactivate

#			Vars
@export var permission :FlowHandler.Permission:
	set(value):
		await ready
		permission = value
		title.permission = permission
		environment.permission = permission
		resources.permission = permission
		anomalies.permission = permission
		author.permission = permission
	get():
		return permission
@export var ftheme :Theme = load('res://Resource/Font/report/type_{0}.tres'.format([randi() % 8])):
	set(value):
		print('res://Resource/Font/report/type_{0}.tres'.format([randi() % 8]))
		ftheme = value
		title.ftheme = ftheme
		environment.ftheme = ftheme
		resources.ftheme = ftheme
		anomalies.ftheme = ftheme
		author.ftheme = ftheme
	get:
		return ftheme

var is_active :bool = false
var is_drag :bool = false
var offset :Vector2 = Vector2.ZERO

@onready var title :Text = $title
@onready var image :TextureRect = $image
@onready var environment :Text = $main/environment/body
@onready var resources :Text = $main/resources/body
@onready var anomalies :Text = $main/anomalies/body
@onready var author :Text = $author


#			Funcs
func _ready() -> void:
	ftheme = ftheme
func _process(delta: float) -> void:
	if is_drag:
		global_position = get_global_mouse_position() - offset

func display() -> void:
	print('\n\t\t{0}\n\t{1}\n{2}\n\n{3}\n{4}\n\n\tby {5}\n'.format([self, title.text, environment.text, resources.text, anomalies.text, author.text]))

func encode() -> void:
	title.encode()
	environment.encode()
	resources.encode()
	anomalies.encode()

func shake() -> void:
	title.shake()
	environment.shake()
	resources.shake()
	anomalies.shake()

func clear() -> void:
	title.clear()
	image = null
	environment.clear()
	resources.clear()
	anomalies.clear()
	author.clear()
func copy(from :Report) -> void:
	title.copy(from.title)
	image = from.image.duplicate()
	environment.copy(from.environment)
	resources.copy(from.resources)
	anomalies.copy(from.anomalies)
	author.copy(from.author)

func get_object(object :String) -> Variant:
	match object:
		"title": return title
		"image": return image
		"environment": return environment
		"resources": return resources
		"anomalies": return anomalies
		"author": return author
		_: printerr('\n{ ', object, ' does not exist... }\n')
	return null
func set_object(object :String, value :Variant) -> void:
	match object:
		"title": title = value
		"image": image = value
		"environment": environment = value
		"resources": resources = value
		"anomalies": anomalies = value
		"author": author = value
		_: printerr('\n{ ', object, ' does not exist... }\n')
func remove_object(object :String) -> Variant:
	var value = null
	match object:
		"title":
			value = title
			title.clear()
		"image":
			value = image
			image = null
		"environment":
			value = environment
			environment.clear()
		"resources":
			value = resources
			resources.clear()
		"anomalies":
			value = anomalies
			anomalies.clear()
		"author":
			value = author
			author.clear()
		_: printerr('\n{ ', object, ' does not exist... }\n')
	return value

func is_empty() -> bool:
	return title.is_empty() and environment.is_empty() and resources.is_empty() and anomalies.is_empty() and image == null


#			Signals
func _on_activate() -> void:
	is_active = true
func _on_deactivate() -> void:
	is_active = false

func _on_button_button_down() -> void:
	offset = get_global_mouse_position() - global_position
	is_drag = true
func _on_button_button_up() -> void:
	is_drag = false

