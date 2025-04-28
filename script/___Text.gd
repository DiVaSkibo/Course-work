extends HFlowContainer
class_name Text

signal activate
signal deactivate

signal word_entered(word :Word, is_entered :bool)
signal word_indicated(word :Word, is_indicated :bool)
signal word_selected(word :Word, is_selected :bool)

signal done

#			Vars
const WORD := preload('res://Scene/___word.tscn')

@export var permission :FlowHandler.Permission
@export_multiline var text :String

var atext :Array[Word] = []
var indication :Array[Word] = []
var selection :Array[Word] = []
var is_active := false
var is_indication := false
var is_shift := false
var shift_word :Word = null


#			Funcs
func _ready() -> void:
	recover_text()
func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_pressed('erase') and permission in [FlowHandler.Permission.Write, FlowHandler.Permission.ReadAndWrite]:
			erase(selection)

func print_atext() -> void:
	for child in get_children():
		remove_child(child)
	for word in atext:
		add_child(word)

func recover_text(is_atext_recovering :bool = true) -> void:
	if is_atext_recovering:
		atext.clear()
		for slicer in text.get_slice_count(' '):
			var aword = WORD.instantiate()
			aword.name = "word_{0}".format([slicer])
			aword.text = text.get_slice(' ', slicer)
			atext.append(aword)
	else:
		var text_ = ''
		for word in get_children():
			if word is Word:
				text_ += word.text + ' '
		text = text_
	print_atext()
	done.emit()

func clear() -> void:
	text = ''
	atext.clear()
	indication.clear()
	selection.clear()
	is_active = false
	is_indication = false
	is_shift = false
	shift_word = null
func copy(from :Text) -> void:
	text = from.text
	atext = from.atext.duplicate()
	indication.clear()
	selection.clear()
	is_active = false
	is_indication = false
	is_shift = false
	shift_word = null

func insert(what :Array[Word], after :Word = null, is_before :bool = false) -> void:
	if what.is_empty() or not permission in [FlowHandler.Permission.Write, FlowHandler.Permission.ReadAndWrite]: return
	if not after: after = atext.back()
	var pos = find(after)
	if !is_before: pos += 1
	for i in range(what.size()):
		var aword = WORD.instantiate()
		aword.name = "new_{0}".format([i])
		aword.text = what[i].text
		atext.insert(pos + i, aword)
	rename(what.front())
	recover_text(false)
func erase(what :Array[Word]) -> Array[Word]:
	for word in what:
		atext.erase(word)
	rename(what[0])
	recover_text(false)
	return what

func find(what :Word) -> int:
	for i in range(atext.size()):
		if atext[i] == what: return i
	return -1
func slice(from :Word = atext.front(), to :Word = atext.back()) -> Array[Word]:
	var words :Array[Word] = []
	var begin = find(from)
	var end = find(to)
	if begin == end: return [from]
	elif begin > end:
		var temp = begin
		begin = end
		end = temp
	for i in range(begin, end + 1):
		words.append(atext[i])
	return words
func next(of :Word) -> Word:
	var pos = find(of) + 1
	if -1 > pos and pos < atext.size(): return atext[pos]
	return null

func rename(what :Word = null) -> void:
	if not what: what = atext.front()
	for i in range(int(what.name.get_slice('_', 1)), atext.size()):
		atext[i].name = "word_{0}".format([i])


func sorting_by_name(a :Word, b :Word) -> bool:
	return a.name.get_slice('_', 1) < b.name.get_slice('_', 1)
func filtering_of_duplications(word :Word) -> bool:
	if selection.find(word, selection.find(word) + 1) != -1: selection.erase(word)
	return true


#			Signals
func _on_activate() -> void:
	is_active = true
	var parent = get_parent()
	if parent is Report or parent is Article:
		parent.activate.emit()
func _on_deactivate() -> void:
	is_active = false
	var parent = get_parent()
	if parent is Report or parent is Article:
		parent.deactivate.emit()
	for selected_word in selection:
		selected_word.select(false, false)
	selection.clear()

func _on_word_entered(which: Word, is_entered: bool = true) -> void:
	if is_entered:
		if is_indication: word_indicated.emit(which)
	else: pass
func _on_word_indicated(which: Word, is_indicated: bool = true) -> void:
	is_indication = true
	#print("||| indication | ", which, " ", is_indicated, " ", is_shift, " ", shift_word, " |||")
	if is_indicated:
		if is_shift:
			if shift_word:
				indication = slice(shift_word, which)
				for word in atext:
					word.indicate(word in indication, false)
			else:
				shift_word = which
		else:
			indication.append(which)
			which.indicate(true, false)
	else:
		indication.erase(which)
	#print('\n  indication\t= ', indication.map(func(o): return o.name))
func _on_word_selected(which: Word, is_selected: bool = true) -> void:
	is_indication = false
	is_shift = false
	if not is_active: FlowHandler.switch(self)
	if is_selected:
		if indication.is_empty(): selection.append(which)
		else: selection.append_array(indication)
	else:
		if indication.is_empty():
			selection.erase(which)
			which.select(false, false)
		else:
			for indicated_word in indication:
				selection.erase(indicated_word)
				indicated_word.select(false, false)
				indicated_word.indicate(false, false)
	indication.clear()
	if selection.is_empty(): FlowHandler.switch()
	else:
		selection.sort_custom(sorting_by_name)
		selection.filter(filtering_of_duplications)
		#print('\n  \tselection\t= ', selection.map(func(o): return o.name))
		for selected_word in selection:
			selected_word.select(true, false)

func _on_done() -> void: pass

