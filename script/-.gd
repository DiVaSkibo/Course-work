extends Control

@onready var report_1: Report = $Report1
@onready var text_1: Text = $Text1
@onready var text_2: Text = $Text2


func _ready() -> void:
	FlowHandler.analyze(self)
	FlowHandler.display()

