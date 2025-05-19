extends Node

#			Vars
enum Permission {none, Read, Write, ReadAndWrite}

const REPORT = preload("res://Scene/__Report.tscn")
const ARTICLE = preload("res://Scene/__Article.tscn")
const INACTIVE_GLPOS :Vector2 = Vector2(.0, 1080)

var ddocs :Dictionary = {
	Interactor.Opject.table: { "Report": [], "Article": [] },
	Interactor.Opject.locker: { "Report": [], "Article": [] },
	Interactor.Opject.locker_double: { "Report": [], "Article": [] }
}
var scene :Node = null
var camera :Camera2D = null
var active :Variant = null
var interactor :Interactor = null
var tween :Tween
var is_coded := false
var is_interacted := false


#			Funcs
func _input(event: InputEvent) -> void:
	if event.is_action_released('save'):
		save_docs()
	if event.is_action_released('ecode'):
		if interactor:
			if is_coded: decode()
			else: encode()
			is_coded = not is_coded
	if event.is_action_pressed('cancel'):
		if active: switch_active(null)

func display() -> void:
	print()
	for opj in ddocs.keys():
		match opj:
			Interactor.Opject.table: print('\tTable :')
			Interactor.Opject.locker: print('\tLocker :')
			Interactor.Opject.locker_double: print('\tLocker-double :')
		print('\t\tReport\t =  ', ddocs[opj]["Report"])
		print('\t\tArticle\t =  ', ddocs[opj]["Article"])
	print()

func analyze(what :Node) -> void:
	var inter
	for opj in ddocs.keys():
		match opj:
			Interactor.Opject.table: inter = what.get_node('Table')
			Interactor.Opject.locker: inter = what.get_node('Locker')
			Interactor.Opject.locker_double: inter = what.get_node('Locker-double')
		if not inter: continue
		for doc in inter.get_children():
			if doc is Report: ddocs[opj]["Report"].append(doc)
			elif doc is Article: ddocs[opj]["Article"].append(doc)

func upload_docs(to :Node) -> void:
	scene = to
	camera = scene.find_child("Eccentric").get_node("Camera2D")
	var section :String
	for opj in ddocs.keys():
		ddocs[opj]["Report"] = []
		ddocs[opj]["Article"] = []
		match opj:
			Interactor.Opject.table: section = "Table"
			Interactor.Opject.locker: section = "Locker"
			Interactor.Opject.locker_double: section = "Locker-double"
		var report_paths = SaveControl.load_config(SaveControl.Sphere.doc, section, "Report")
		for resource_path in report_paths:
			var resource = SaveControl.load_resource_doc(resource_path)
			var report = REPORT.instantiate()
			report.name = resource.resource_name
			report.resource = resource
			report.global_position = to.get_node("MarkerReport").global_position
			to.get_node(section).add_child(report)
			ddocs[opj]["Report"].append(report)
		var article_paths = SaveControl.load_config(SaveControl.Sphere.doc,section, "Article")
		for resource_path in article_paths:
			var resource = SaveControl.load_resource_doc(resource_path)
			var article = ARTICLE.instantiate()
			article.name = resource.resource_name
			article.resource = resource
			article.global_position = to.get_node("MarkerArticle").global_position
			to.get_node(section).add_child(article)
			ddocs[opj]["Article"].append(article)
func save_docs() -> void:
	var section :String
	for opj in ddocs.keys():
		match opj:
			Interactor.Opject.table: section = "Table"
			Interactor.Opject.locker: section = "Locker"
			Interactor.Opject.locker_double: section = "Locker-double"
		var resources_report = []
		for report in ddocs[opj]["Report"]:
			resources_report.append(report.resource.resource_path)
		SaveControl.save_config(SaveControl.Sphere.doc, section, "Report", resources_report)
		var resources_article = []
		for article in ddocs[opj]["Article"]:
			resources_article.append(article.resource.resource_path)
		SaveControl.save_config(SaveControl.Sphere.doc, section, "Article", resources_article)

func create_doc(what :StringName) -> void:
	if interactor:
		if interactor.opject in [Interactor.Opject.table, Interactor.Opject.locker, Interactor.Opject.locker_double]:
			var resource
			var document
			match what:
				"Report":
					resource = SaveControl.load_resource_doc("res://Resource/Report_0.tres")
					document = REPORT.instantiate()
				"Article":
					resource = SaveControl.load_resource_doc("res://Resource/Article_0.tres")
					document = ARTICLE.instantiate()
			document.name = resource.resource_name
			document.resource = resource
			if document is Report: document.global_position = scene.get_node("MarkerReport").global_position
			elif document is Article: document.global_position = scene.get_node("MarkerArticle").global_position
			var inter
			match interactor.opject:
				Interactor.Opject.table: inter = "Table"
				Interactor.Opject.locker: inter = "Locker"
				Interactor.Opject.locker_double: inter = "Locker-double"
			scene.get_node(inter).add_child(document)
			ddocs[interactor.opject][what].append(document)

func encode() -> void:
	if interactor.opject in ddocs.keys():
		for report in ddocs[interactor.opject]["Report"]: report.encode()
		for article in ddocs[interactor.opject]["Article"]: article.encode()
func decode() -> void:
	if interactor.opject in ddocs.keys():
		for report in ddocs[interactor.opject]["Report"]: report.decode()
		for article in ddocs[interactor.opject]["Article"]: article.decode()

func switch_opject(of :Document, to :Interactor.Opject) -> void:
	var from := find_opject(of)
	if of is Report:
		ddocs[to]["Report"].append(of)
		ddocs[from]["Report"].erase(of)
	if of is Article:
		ddocs[to]["Article"].append(of)
		ddocs[from]["Article"].erase(of)

func switch_active(to :Variant = null) -> void:
	#print('switch_active\t', active, '\t->\t', to)
	if active: active.deactivate.emit()
	if to: to.activate.emit()
	active = to

func interact(is_interaction :bool = true, is_out :bool = false) -> void:
	is_interacted = is_interaction
	camera._zoom(is_interaction)
	if tween: tween.kill()
	if interactor.opject in range(1, 4): tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	if is_interaction:
		GlobalHandler.set_default_clear_color(Color.from_hsv(interactor.color.h, interactor.color.s - .1, interactor.color.v - .2))
		match interactor.opject:
			Interactor.Opject.table: tween.tween_property(scene.get_node("Table"), "global_position", Vector2.ZERO, 1.8)
			Interactor.Opject.locker: tween.tween_property(scene.get_node("Locker"), "global_position", Vector2.ZERO, 1.8)
			Interactor.Opject.locker_double: tween.tween_property(scene.get_node("Locker-double"), "global_position", Vector2.ZERO, 1.8)
			Interactor.Opject.plant: pass
			Interactor.Opject.clock: pass
	else:
		GlobalHandler.set_default_clear_color()
		match interactor.opject:
			Interactor.Opject.table: tween.tween_property(scene.get_node("Table"), "global_position", INACTIVE_GLPOS, 1.4)
			Interactor.Opject.locker: tween.tween_property(scene.get_node("Locker"), "global_position", INACTIVE_GLPOS, 1.4)
			Interactor.Opject.locker_double: tween.tween_property(scene.get_node("Locker-double"), "global_position", INACTIVE_GLPOS, 1.4)
			Interactor.Opject.plant: pass
			Interactor.Opject.clock: pass
	if is_out: interactor = null

func find_opject(of :Document) -> Interactor.Opject:
	for opj in ddocs.keys():
		if of is Report:
			if of in ddocs[opj]["Report"]: return opj
		if of is Article:
			if of in ddocs[opj]["Article"]: return opj
	return Interactor.Opject.none

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

