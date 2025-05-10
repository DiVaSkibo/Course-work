extends CharacterBody2D
class_name Eccentric

#			Vars
@export var color :Color = Color.from_hsv(randf(), .4, .7):
	set(value): modulate = value
	get: return modulate
@export_range(0., 300.) var speed :float = 150.

var gravity :float = 10. * ProjectSettings.get_setting("physics/2d/default_gravity")
var interactor :Variant = null


#		FUNC
func _physics_process(delta :float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _input(event :InputEvent) -> void:
	if event.is_action_released("interact") and interactor: interactor.interact(!interactor.is_active)
	if event.is_action_released("run"): speed /= 2
	elif event.is_action_pressed("run"): speed *= 2


#			Signals


