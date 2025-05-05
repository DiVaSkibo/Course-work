extends Node

@onready var report :Report = $Report
@onready var article :Article = $Article
@onready var text: Text = $Text


func _ready() -> void:
	FlowHandler.analyze(self)
	FlowHandler.display()

