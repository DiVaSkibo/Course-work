extends Sprite2D
class_name Interactor

#			Vars
enum Opject {none, table, locker, locker_double, plant, clock}

@export var opject :Opject = Opject.none
@export var color :Color = GlobalHandler.default_clear_color

var camera :Camera2D = null
var is_active := false


#			Funcs
func interact(is_interaction :bool = true) -> void:
	is_active = is_interaction
	camera._zoom(is_active)
	if is_active:
		GlobalHandler.set_default_clear_color(Color.from_hsv(color.h, color.s - .1, color.v - .2))
		match opject:
			Opject.table: pass
			Opject.locker: pass
			Opject.locker_double: pass
			Opject.plant: pass
			Opject.clock: pass
	else: GlobalHandler.set_default_clear_color()


#			Signals
func _on_body_entered(body: Node2D) -> void:
	if body is Eccentric:
		FlowHandler.interactor = self
		if not camera: camera = body.find_child("Camera2D")
func _on_body_exited(body: Node2D) -> void:
	if body is Eccentric:
		FlowHandler.interactor = null
		interact(false)

