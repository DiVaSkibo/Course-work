extends CharacterBody2D
class_name Eccentric

#			Vars
@export_range(0., 300.) var speed :float = 160.

var gravity :float = ProjectSettings.get_setting("physics/2d/default_gravity")


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
	if event.is_action_released("interact") and FlowHandler.interactor: FlowHandler.interact(!FlowHandler.is_interacted)
	if event.is_action_released("run"): speed /= 2
	elif event.is_action_pressed("run"): speed *= 2


#			Signals


