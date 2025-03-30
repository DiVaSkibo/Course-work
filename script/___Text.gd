extends HFlowContainer
class_name Text

signal deactivate

signal word_entered(word :Word, is_entered :bool)
signal word_indicated(word :Word, is_indicated :bool)
signal word_selected(word :Word, is_selected :bool)

signal done

#			Vars
enum Permission {none, Read, Write, ReadAndWrite}

const WORD := preload('res://Scene/___word.tscn')

@export var permission :Permission
@export_multiline var text :String

var atext :Array[Word] = []
var indication :Array[Word] = []
var selection :Array[Word] = []
var is_active := false
var is_indication := false


#			Funcs
func _ready() -> void:
	recover_text()

func print_atext() -> void:
	for child in get_children():
		remove_child(child)
	for word in atext:
		add_child(word)

func recover_text(is_atext_recovering :bool = true) -> void:
	if is_atext_recovering:
		atext.clear()
		for slice in text.get_slice_count(' '):
			var aword = WORD.instantiate()
			aword.name = "word_{0}".format([slice])
			aword.text = text.get_slice(' ', slice)
			atext.append(aword)
	else:
		var text_ = ''
		for word in get_children():
			if word is Word:
				text_ += word.text + ' '
		text = text_
	print_atext()
	done.emit()

func insert(words :Array[Word], after :Word = null) -> void:
	if not permission in [Permission.Write, Permission.ReadAndWrite]: return
	if not after:
		after = atext.back()
	var pos = int(after.name.get_slice('_', 1)) + 1
	for i in range(words.size()):
		var aword = WORD.instantiate()
		aword.name = "new_{0}".format([i])
		aword.text = words[i].text
		atext.insert(pos + i, aword)
	rename(words.front())
	recover_text(false)
func erase(words :Array[Word]) -> Array[Word]:
	for word in words:
		atext.erase(word)
	rename(words[0])
	recover_text(false)
	return words

func rename(word :Word = null) -> void:
	if not word:
		word = atext.front()
	for i in range(int(word.name.get_slice('_', 1)), atext.size()):
		atext[i].name = "word_{0}".format([i])


func sorting_by_name(a :Word, b :Word) -> bool:
	return a.name.get_slice('_', 1) < b.name.get_slice('_', 1)
func filtering_of_duplications(word :Word) -> bool:
	if selection.find(word, selection.find(word) + 1) != -1:
		selection.erase(word)
	return true


#			Signals
func _on_deactivate() -> void:
	is_active = false
	for selected_word in selection:
		selected_word.select(false, false)
	selection.clear()

func _on_word_entered(word: Word, is_entered: bool = true) -> void:
	if is_entered:
		if is_indication and indication.find(word) == -1:
			indication.append(word)
			word.indicate()
	else:
		if is_indication and indication.find(word) == -1:
			indication.erase(word)
			word.indicate(false)
func _on_word_indicated(word: Word, is_indicated: bool = true) -> void:
	is_indication = is_indicated
	if is_indicated:
		indication.append(word)
	else:
		indication.clear()
	#print('\n  indication\t= ', indication.map(func(o): return o.name))
func _on_word_selected(word: Word, is_selected: bool = true) -> void:
	is_indication = false
	is_active = true
	FlowTextHandler.switch(self)
	if is_selected:
		if indication.is_empty():
			selection.append(word)
		else:
			selection.append_array(indication)
	else:
		if indication.is_empty():
			selection.erase(word)
			word.select(false, false)
		else:
			for indicated_word in indication:
				selection.erase(indicated_word)
				indicated_word.select(false, false)
				indicated_word.indicate(false, false)
	indication.clear()
	if selection.is_empty():
		deactivate.emit()
	else:
		selection.sort_custom(sorting_by_name)
		selection.filter(filtering_of_duplications)
		print('\n  \tselection\t= ', selection.map(func(o): return o.name))
		for selected_word in selection:
			selected_word.select(true, false)

func _on_done() -> void:
	pass

