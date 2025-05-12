extends Control
class_name Article

signal activate
signal deactivate

#			Vars
enum Error {none, Empty, Size}

@export var permission :FlowHandler.Permission:
	set(value):
		await ready
		permission = value
		header.permission = permission
		body.permission = permission
	get():
		return permission
@export var key :Array[Variant] = [null, null]
@export var cipher :SecurityHandler.Cipher = SecurityHandler.Cipher.none
@export var ftheme :Theme = load('res://Resource/Font/article/Pixel.tres'):
	set(value):
		ftheme = value
		header.ftheme = ftheme
		body.ftheme = ftheme
	get:
		return ftheme

var is_active := false
var is_drag := false
var offset := Vector2.ZERO

@onready var header :Text = $header/body
@onready var image :TextureRect = $image
@onready var body :Text = $body/body


#			Funcs
func _ready() -> void:
	ftheme = ftheme
func _process(delta: float) -> void:
	if is_drag: global_position = get_global_mouse_position() - offset

func display() -> void:
	print('\n\t\t{0}\n\t{1}\n\n{3}\n{4}\n'.format([self, header.text, body.text]))

func encode() -> void:
	header.encode()
	body.encode()
func decode() -> void:
	header.decode()
	body.decode()

func clear() -> void:
	header.clear()
	image = null
	body.clear()
func copy(from :Article) -> void:
	header.copy(from.header)
	image = from.image.duplicate()
	body.copy(from.body)

func is_empty() -> bool:
	return header.is_empty() and body.is_empty() and image == null

func analyze() -> bool:
	return SecurityHandler.analyze(header, key, cipher) and SecurityHandler.analyze(body, key, cipher)


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

