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
var is_coded := false


#			Funcs
func _input(event: InputEvent) -> void:
	if event.is_action_released('ecode'):
		if is_coded: decode()
		else: encode()
		is_coded = not is_coded
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

func encode() -> void:
	for perm in Permission.values():
		for report in dreports[perm]: report.encode()
		for article in darticles[perm]: article.encode()
func decode() -> void:
	for perm in Permission.values():
		for report in dreports[perm]: report.decode()
		for article in darticles[perm]: article.decode()

func switch(to :Variant = null) -> void:
	#print('switch\t', active, '\t->\t', to)
	if active: active.deactivate.emit()
	if to: to.activate.emit()
	active = to

func get_selection() -> Array[Word]:
	if active: return active.selection
	return []

func insert_selection(into :Text, after :Word = null, is_before :bool = false) -> void:
	var selection = get_selection()
	if not selection.is_empty():
		if into == active:
			into.insert(into.erase(selection), after, is_before)
			active.deactivate.emit()
		else:
			into.insert(selection, after, is_before)

