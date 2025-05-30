extends Node

#			Vars
enum Permission {none, Read, Write, ReadAndWrite}

const REPORT = preload("res://Scene/__Report.tscn")
const ARTICLE = preload("res://Scene/__Article.tscn")
const INACTIVE_GLPOS :Vector2 = Vector2(.0, 1152.)

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

func display_docs() -> void:
	display()
	for sopject in ["Table", "Locker", "Locker-double"]:
		var opject = scene.get_node(sopject)
		for child in opject.get_children():
			var tween_disapear = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			tween_disapear.tween_property(child, "modulate:a", .0, .6)
			await tween_disapear.finished
			opject.remove_child(child)
	for opj in ddocs.keys():
		var opject
		match opj:
			Interactor.Opject.table: opject = scene.get_node("Table")
			Interactor.Opject.locker: opject = scene.get_node("Locker")
			Interactor.Opject.locker_double: opject = scene.get_node("Locker-double")
		for report in ddocs[opj]["Report"]:
			report.global_position = scene.get_node("MarkerReport").global_position
			if not report in opject.get_children(): opject.add_child(report)
			var tween_apear = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween_apear.tween_property(report, "modulate:a", 1., .6)
			await tween_apear.finished
		for article in ddocs[opj]["Article"]:
			article.global_position = scene.get_node("MarkerArticle").global_position
			if not article in opject.get_children(): opject.add_child(article)
			var tween_apear = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween_apear.tween_property(article, "modulate:a", 1., .6)
			await tween_apear.finished
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
			if not resource: continue
			var report = REPORT.instantiate()
			report.name = "Report_{0}".format([resource.title])
			report.resource = resource
			report.global_position = to.get_node("MarkerReport").global_position
			ddocs[opj]["Report"].append(report)
		var article_paths = SaveControl.load_config(SaveControl.Sphere.doc,section, "Article")
		for resource_path in article_paths:
			var resource = SaveControl.load_resource_doc(resource_path)
			if not resource: continue
			var article = ARTICLE.instantiate()
			article.name = "Article_{0}".format([resource.title])
			article.resource = resource
			article.global_position = to.get_node("MarkerArticle").global_position
			ddocs[opj]["Article"].append(article)
	display_docs()
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
		if interactor.opject == Interactor.Opject.table:
			if not ddocs[Interactor.Opject.table][what].is_empty():
				ddocs[Interactor.Opject.table][what].clear()
			var document
			match what:
				"Report": document = REPORT.instantiate()
				"Article":
					if not ddocs[Interactor.Opject.table]["Report"].is_empty(): document = ARTICLE.instantiate()
					else: return
			if document is Report:
				var resource = SaveControl.load_resource_doc("res://Resource/Report_{0}.tres".format([GlobalHandler.PLANETS.pick_random()]))
				document.resource = resource
				document.global_position = scene.get_node("MarkerReport").global_position
				document.name = "Report_{0}".format([resource.title])
			elif document is Article:
				var resource := DocumentResource.new()
				var report = ddocs[interactor.opject]["Report"].front()
				resource.permission = Permission.ReadAndWrite
				resource.key = report.key
				resource.cipher = report.cipher
				if report.ftheme:
					resource.ftheme = report.ftheme
				resource.image = report.image.texture as CompressedTexture2D
				document.resource = resource
				document.global_position = scene.get_node("MarkerArticle").global_position
				document.name = "Article_{0}".format([report.title.text])
				resource.resource_path = "res://Resource/{0}.tres".format([document.name])
				resource.resource_name = document.name
			var inter
			match interactor.opject:
				Interactor.Opject.table: inter = "Table"
				Interactor.Opject.locker: inter = "Locker"
				Interactor.Opject.locker_double: inter = "Locker-double"
			scene.get_node(inter).add_child(document)
			document.modulate.a = .0
			ddocs[interactor.opject][what].append(document)
			if document is Report: document.shake()
			display_docs()
func move_doc(what :Document, to :Interactor.Opject) -> void:
	var from :Interactor.Opject
	var type :StringName
	if what is Report: type = "Report"
	elif what is Article: type = "Article"
	for opj in ddocs.keys():
		if what in ddocs[opj][type]:
			from = opj
	ddocs[to][type].append(what)
	ddocs[from][type].erase(what)

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
	if interactor.opject in [Interactor.Opject.table, Interactor.Opject.locker, Interactor.Opject.locker_double]: camera._zoom(is_interaction)
	if tween: tween.kill()
	if interactor.opject in range(1, 4): tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	if is_interaction:
		GlobalHandler.set_default_clear_color(Color.from_hsv(interactor.color.h, interactor.color.s - .1, interactor.color.v - .2))
		match interactor.opject:
			Interactor.Opject.table: tween.tween_property(scene.get_node("Table"), "global_position", Vector2.ZERO, 1.8)
			Interactor.Opject.locker: tween.tween_property(scene.get_node("Locker"), "global_position", Vector2.ZERO, 1.8)
			Interactor.Opject.locker_double: tween.tween_property(scene.get_node("Locker-double"), "global_position", Vector2.ZERO, 1.8)
			Interactor.Opject.plant: Dialogic.start("Plant")
			Interactor.Opject.clock: Dialogic.start("Clock")
	else:
		GlobalHandler.set_default_clear_color()
		match interactor.opject:
			Interactor.Opject.table: tween.tween_property(scene.get_node("Table"), "global_position", INACTIVE_GLPOS, 1.4)
			Interactor.Opject.locker: tween.tween_property(scene.get_node("Locker"), "global_position", INACTIVE_GLPOS, 1.4)
			Interactor.Opject.locker_double: tween.tween_property(scene.get_node("Locker-double"), "global_position", INACTIVE_GLPOS, 1.4)
			Interactor.Opject.plant: Dialogic.end_timeline()
			Interactor.Opject.clock: Dialogic.end_timeline()
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

