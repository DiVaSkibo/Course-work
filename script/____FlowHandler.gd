extends Node

#			Vars
enum Permission {none, Read, Write, ReadAndWrite}

const REPORT = preload("res://Scene/__Report.tscn")
const ARTICLE = preload("res://Scene/__Article.tscn")

var ddocs :Dictionary = {
	Interactor.Opject.table: { "Report": [], "Article": [] },
	Interactor.Opject.locker: { "Report": [], "Article": [] },
	Interactor.Opject.locker_double: { "Report": [], "Article": [] }
}
var active :Variant = null
var interactor :Interactor = null
var is_coded := false


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

func analyze(scene :Node) -> void:
	var inter
	for opj in ddocs.keys():
		match opj:
			Interactor.Opject.table: inter = scene.get_node('Table')
			Interactor.Opject.locker: inter = scene.get_node('Locker')
			Interactor.Opject.locker_double: inter = scene.get_node('Locker-double')
		if not inter: continue
		for doc in inter.get_children():
			if doc is Report: ddocs[opj]["Report"].append(doc)
			elif doc is Article: ddocs[opj]["Article"].append(doc)

func upload_docs(scene :Node) -> void:
	var section :String
	for opj in ddocs.keys():
		ddocs[opj]["Report"] = []
		ddocs[opj]["Article"] = []
		match opj:
			Interactor.Opject.table: section = "Table"
			Interactor.Opject.locker: section = "Locker"
			Interactor.Opject.locker_double: section = "Locker-double"
		var report_paths = SaveControl.load_config_doc(section, "Report")
		for resource_path in report_paths:
			var resource = SaveControl.load_resource_doc(resource_path)
			var report = REPORT.instantiate()
			report.name = resource.resource_name
			report.resource = resource
			report.global_position = scene.get_node("MarkerReport").global_position
			scene.get_node(section).add_child(report)
			ddocs[opj]["Report"].append(report)
		var article_paths = SaveControl.load_config_doc(section, "Article")
		for resource_path in article_paths:
			var resource = SaveControl.load_resource_doc(resource_path)
			var article = ARTICLE.instantiate()
			article.name = resource.resource_name
			article.resource = resource
			article.global_position = scene.get_node("MarkerArticle").global_position
			scene.get_node(section).add_child(article)
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
		SaveControl.save_config_doc(section, "Report", resources_report)
		var resources_article = []
		for article in ddocs[opj]["Article"]:
			resources_article.append(article.resource.resource_path)
		SaveControl.save_config_doc(section, "Article", resources_article)

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


func filtering_of_report(doc :Document) -> bool:
	return doc is Report
func filtering_of_article(doc :Document) -> bool:
	return doc is Article

