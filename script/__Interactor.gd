extends Sprite2D
class_name Interactor

#			Vars
enum Opject {none, table, locker, locker_double, plant, clock}

@export var opject :Opject = Opject.none

var camera :Camera2D = null
var is_active := false


#			Funcs
func interact(is_interaction :bool = true) -> void:
	is_active = is_interaction
	camera._zoom(is_active)
	if is_active:
		match opject:
			Opject.table: pass
			Opject.locker: pass
			Opject.locker_double: pass
			Opject.plant: pass
			Opject.clock: pass


#			Signals
func _on_body_entered(body: Node2D) -> void:
	if body is Eccentric:
		body.interactor = self
		if not camera: camera = body.find_child("Camera2D")
func _on_body_exited(body: Node2D) -> void:
	if body is Eccentric:
		body.interactor = null
		interact(false)

