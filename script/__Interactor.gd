extends Sprite2D
class_name Interactor

#			Vars
enum Opject {none, table, locker, locker_double, plant, clock}

@export var opject :Opject = Opject.none
@export var color :Color = GlobalHandler.default_clear_color


#			Signals
func _on_body_entered(body: Node2D) -> void:
	if body is Eccentric:
		FlowHandler.interactor = self
func _on_body_exited(body: Node2D) -> void:
	if body is Eccentric and FlowHandler.interactor:
		FlowHandler.interact(false)

