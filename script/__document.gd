extends Control
class_name Document

signal activate
signal deactivate

#			Vars
@export var resource :DocumentResource

var permission :FlowHandler.Permission:
	set(value):
		resource.permission = value
		title.permission = resource.permission
		environment.permission = resource.permission
		resources.permission = resource.permission
		anomalies.permission = resource.permission
	get:
		return resource.permission
var key :Array[Variant]:
	set(value): resource.key = value
	get: return resource.key
var cipher :SecurityHandler.Cipher:
	set(value): resource.cipher = value
	get: return resource.cipher
var ftheme :Theme:
	set(value):
		resource.ftheme = value
		title.ftheme = resource.ftheme
		environment.ftheme = resource.ftheme
		resources.ftheme = resource.ftheme
		anomalies.ftheme = resource.ftheme
	get:
		return resource.ftheme
var is_active := false
var is_drag := false
var offset := Vector2.ZERO

@onready var title :Text = $title
@onready var image :TextureRect = $image
@onready var environment :Text = $main/environment/body
@onready var resources :Text = $main/resources/body
@onready var anomalies :Text = $main/anomalies/body


#			Funcs
func _ready() -> void:
	permission = resource.permission
	if resource.ftheme: ftheme = resource.ftheme
	title.text = resource.title
	title.recover(true)
	image.texture = resource.image
	environment.text = resource.environment
	environment.recover(true)
	resources.text = resource.resources
	resources.recover(true)
	anomalies.text = resource.anomalies
	anomalies.recover(true)
	title.encrypt(key, cipher)
	environment.encrypt(key, cipher)
	resources.encrypt(key, cipher)
	anomalies.encrypt(key, cipher)
func _process(_delta: float) -> void:
	if is_drag: global_position = get_global_mouse_position() - offset

func display() -> void:
	print('\n\t\t{0}\n\t{1}\n{2}\n\n{3}\n{4}\n'.format([self, title.text, environment.text, resources.text, anomalies.text]))

func analyze() -> bool:
	return SecurityHandler.analyze(environment, key, cipher) and SecurityHandler.analyze(resources, key, cipher) and SecurityHandler.analyze(anomalies, key, cipher)

func encode() -> void:
	title.encode()
	environment.encode()
	resources.encode()
	anomalies.encode()
func decode() -> void:
	title.decode()
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
func copy(from :Document) -> void:
	title.copy(from.title)
	image = from.image.duplicate()
	environment.copy(from.environment)
	resources.copy(from.resources)
	anomalies.copy(from.anomalies)

func update_resource() -> void:
	title.recover()
	resource.title = title.text
	resource.image = image.texture
	environment.recover()
	resource.environment = environment.text
	environment.recover()
	resource.resources = resources.text
	anomalies.recover()
	resource.anomalies = anomalies.text

func is_empty() -> bool:
	return title.is_empty() or environment.is_empty() or resources.is_empty() or anomalies.is_empty() or image.texture == null


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

