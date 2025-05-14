extends Resource
class_name DocumentResource

@export_group("Information")
@export var permission :FlowHandler.Permission
@export var key :Array[Variant] = [null, null]
@export var cipher :SecurityHandler.Cipher = SecurityHandler.Cipher.none
@export var ftheme :Theme

@export_group("Content")
@export var title :String
@export var image :CompressedTexture2D
@export var environment :String
@export var resources :String
@export var anomalies :String


func copy(from :DocumentResource) -> void:
	resource_name = from.resource_name
	permission = from.permission
	key = from.key
	cipher = from.cipher
	ftheme = from.ftheme
	title = from.title
	image = from.image
	environment = from.environment
	resources = from.resources
	anomalies = from.anomalies

