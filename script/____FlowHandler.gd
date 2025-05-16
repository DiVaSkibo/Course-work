extends Node

#			Vars
enum Permission {none, Read, Write, ReadAndWrite}

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
	if event.is_action_released('ecode'):
		if is_coded: decode()
		else: encode()
		is_coded = not is_coded
	if event.is_action_pressed('cancel'):
		if active: switch_active(null)

func display() -> void:
	for opj in ddocs.keys():
		match opj:
			Interactor.Opject.table: print('\n\tTable =')
			Interactor.Opject.locker: print('\n\tLocker =')
			Interactor.Opject.locker_double: print('\n\tLocker-double =')
		print('\t\tReports : ', ddocs[opj]["Report"])
		print('\t\tArticle : ', ddocs[opj]["Article"])
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
	var docs = SaveControl.load_config_doc("Table")
	ddocs[Interactor.Opject.table]["Report"] = [docs.filter(filtering_of_report)]
	ddocs[Interactor.Opject.table]["Article"] = [docs.filter(filtering_of_article)]
	docs = SaveControl.load_config_doc("Locker")
	ddocs[Interactor.Opject.locker]["Report"] = [docs.filter(filtering_of_report)]
	ddocs[Interactor.Opject.locker]["Article"] = [docs.filter(filtering_of_article)]
	docs = SaveControl.load_config_doc("Locker-double")
	ddocs[Interactor.Opject.locker_double]["Report"] = [docs.filter(filtering_of_report)]
	ddocs[Interactor.Opject.locker_double]["Article"] = [docs.filter(filtering_of_article)]

func encode() -> void:
	for opj in Interactor.Opject.values():
		for report in opj["Report"]: report.encode()
		for article in opj["Article"]: article.encode()
func decode() -> void:
	for opj in Interactor.Opject.values():
		for report in opj["Report"]: report.decode()
		for article in opj["Article"]: article.decode()

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

