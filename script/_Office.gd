extends Node


#			Funcs
func _ready() -> void:
	FlowHandler.upload_docs(self)
	FlowHandler.display()

