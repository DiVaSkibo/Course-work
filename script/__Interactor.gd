extends Area2D
class_name Interactor

#			Vars
var is_active := false


#			Funcs
func interact(is_interaction :bool = true) -> void:
	is_active = is_interaction


#			Signals
func _on_body_entered(body: Node2D) -> void:
	if body is Eccentric: body.interactor = self
func _on_body_exited(body: Node2D) -> void:
	if body is Eccentric:
		body.interactor = null
		interact(false)

