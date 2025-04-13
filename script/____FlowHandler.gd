extends Node

#			Vars
enum Permission {none, Read, Write, ReadAndWrite}

var dreports :Dictionary = {
	Permission.none: [],
	Permission.Read: [],
	Permission.Write: [],
	Permission.ReadAndWrite: []
}
var darticles :Dictionary = {
	Permission.none: [],
	Permission.Read: [],
	Permission.Write: [],
	Permission.ReadAndWrite: []
}
var dtexts :Dictionary = {
	Permission.none: [],
	Permission.Read: [],
	Permission.Write: [],
	Permission.ReadAndWrite: []
}
var active :Variant = null


#			Funcs
func _input(event: InputEvent) -> void:
	if event.is_action_pressed('cancel'):
		if active: switch(null)

func display() -> void:
	print('\n   dreports  =\t', dreports.get(Permission.none))
	print('\t\t\t\t', dreports.get(Permission.Read))
	print('\t\t\t\t', dreports.get(Permission.Write))
	print('\t\t\t\t', dreports.get(Permission.ReadAndWrite))
	print('  darticles  =\t', darticles.get(Permission.none))
	print('\t\t\t\t', darticles.get(Permission.Read))
	print('\t\t\t\t', darticles.get(Permission.Write))
	print('\t\t\t\t', darticles.get(Permission.ReadAndWrite))
	print('\t dtexts  =\t', dtexts.get(Permission.none))
	print('\t\t\t\t', dtexts.get(Permission.Read))
	print('\t\t\t\t', dtexts.get(Permission.Write))
	print('\t\t\t\t', dtexts.get(Permission.ReadAndWrite))
	print()

func analyze(scene :Node) -> void:
	for obj in scene.get_children():
		if obj is Report: dreports[obj.permission].append(obj)
		elif obj is Article: darticles[obj.permission].append(obj)
		elif obj is Text: dtexts[obj.permission].append(obj)

func switch(to :Variant = null) -> void:
	#print('switch\t', active, '\t->\t', to)
	if active: active.deactivate.emit()
	if to: to.activate.emit()
	active = to

#func find_active(type :String = "", skip :Array[Variant] = []) -> Variant:
	#if type in ["", "Report"]:
		#for permission in Permission.values():
			#for obj in dreports[permission]:
				#if obj.is_active and obj not in skip:
					#return find_inside(obj)
	#if type in ["", "Article"]:
		#for permission in Permission.values():
			#for obj in darticles[permission]:
				#if obj.is_active and obj not in skip:
					#return find_inside(obj)
	#if type in ["", "Text"]:
		#for permission in Permission.values():
			#for obj in dtexts[permission]:
				#if obj.is_active and obj not in skip:
					#return obj
	#return null
#func find_inside(object :Node) -> Text:
	#for obj in object.get_children():
		#if obj is Text:
			#if obj.is_active: return obj
	#return null
func find_selection() -> Array[Word]:
	if active: return active.selection
	return []

