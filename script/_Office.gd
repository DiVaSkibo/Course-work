extends Node


func _ready() -> void:
	FlowHandler.analyze(self)
	FlowHandler.display()

