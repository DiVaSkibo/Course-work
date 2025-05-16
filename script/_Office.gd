extends Node

#			Vars
const REPORT = preload("res://Scene/__Report.tscn")
const ARTIRCLE = preload("res://Scene/__Article.tscn")


#			Funcs
func _ready() -> void:
	#var report := REPORT.instantiate()
	#report.name = 'Report1'
	#print($Report.resource.resource_name)
	#report.resource = SaveControl.load_resource_doc($Report.resource.resource_name)
	#report.global_position = $Article.global_position + Vector2(.0, 300.)
	#print(report.resource)
	#add_child(report)
	FlowHandler.analyze(self)
	FlowHandler.display()
	#report.image.texture = load('res://Resource/Assets/planet/planet_2_2.png')
	FlowHandler.switch_opject($Table/Report, Interactor.Opject.locker_double)
	FlowHandler.display()

