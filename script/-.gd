extends Control

@onready var text_1: Text = $Text1
@onready var text_2: Text = $Text2


func _ready() -> void:
	FlowTextHandler.analyze(self)
	#print(text_2.atext)
	#await $Timer.timeout
	#if text_2.permission in [Text.Permission.Write, Text.Permission.ReadAndWrite]:
		#text_2.insert(text_1.atext, text_2.atext[1])
		#print(text_2.atext.map(func(o): return o.name))
	#await $Timer.timeout
	pass

