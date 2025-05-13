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
@export var key :Array[Variant] = [null, null]
@export var cipher :SecurityHandler.Cipher = SecurityHandler.Cipher.none
@export var ftheme :Theme:
	set(value):
		await ready
		ftheme = value
		title.ftheme = ftheme
		environment.ftheme = ftheme
		resources.ftheme = ftheme
		anomalies.ftheme = ftheme
		author.ftheme = ftheme
	get:
		return ftheme

var is_active := false
var is_drag := false
var offset := Vector2.ZERO

@onready var title :Text = $title
@onready var image :TextureRect = $image
@onready var environment :Text = $main/environment/body
@onready var resources :Text = $main/resources/body
@onready var anomalies :Text = $main/anomalies/body
@onready var author :Text = $author


#			Funcs
func _ready() -> void:
	title.encrypt(key, cipher)
	environment.encrypt(key, cipher)
	resources.encrypt(key, cipher)
	anomalies.encrypt(key, cipher)
func _process(_delta: float) -> void:
	if is_drag: global_position = get_global_mouse_position() - offset

func display() -> void:
	print('\n\t\t{0}\n\t{1}\n{2}\n\n{3}\n{4}\n\n\tby {5}\n'.format([self, title.text, environment.text, resources.text, anomalies.text, author.text]))

func encode() -> void:
	environment.encode()
	resources.encode()
	anomalies.encode()
func decode() -> void:
	environment.decode()
	resources.decode()
	anomalies.decode()

func shake() -> void:
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

