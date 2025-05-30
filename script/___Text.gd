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
@export var ftheme :Theme:
	set(value):
		ftheme = value
		for word in atext:
			word.theme = ftheme
		fsize = fsize
	get:
		return ftheme
@export var fsize :int:
	set(value):
		fsize = value
		for word in atext:
			word.add_theme_font_size_override("font_size", fsize)
	get:
		return fsize

var atext :Array[Word] = []
var indication :Array[Word] = []
var selection :Array[Word] = []
var is_active := false
var is_indication := false
var is_shift := false
var shift_word :Word = null


#			Funcs
func _ready() -> void:
	if text.is_empty():
		text = '{' + Word.FILL + '}'
	recover(true)
func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_pressed('erase') and permission in [FlowHandler.Permission.Write, FlowHandler.Permission.ReadAndWrite]:
			erase(selection)
			FlowHandler.switch_active()

func encrypt(key :Array, cipher :SecurityHandler.Cipher) -> void:
	const SYMBOLS := [['(',')','[',']'], ['|','!']]
	var isentence = 0
	var j = 0
	var symbol :Array[String] = [SYMBOLS[0].pick_random(), SYMBOLS[1].pick_random()]
	for i in atext.size():
		var word = atext[i]
		word.code = SecurityHandler.encrypt([isentence, i - j], key, cipher, symbol)
		for end in ['.','!','?']:
			if word.text.ends_with(end):
				isentence += 1
				j = i + 1
				symbol[0] = SYMBOLS[0].filter(func(s): return s != symbol[0]).pick_random()
				symbol[1] = SYMBOLS[1].filter(func(s): return s != symbol[1]).pick_random()
				break

func encode() -> void:
	for word in atext: word.encode()
func decode() -> void:
	for word in atext: word.decode()

func shake() -> void:
	var isentence := 0
	var ifront := 0
	var iback := 0
	for i in atext.size():
		var isentence_ := SecurityHandler.decrypt(atext[i].code, get_parent().get_parent().get_parent().key, get_parent().get_parent().get_parent().cipher)[0]
		if isentence_ != isentence or i + 1 == atext.size():
			if isentence_ != isentence: iback = i - 1
			else: iback = i
			var sentence := slice(atext[ifront], atext[iback])
			for j in range(ifront, iback): atext[j] = null
			for word in sentence:
				if word == sentence.back(): break
				var rpos = randi_range(ifront, iback - 1)
				while atext[rpos]:
					rpos = randi_range(ifront, iback - 1)
				atext[rpos] = word
			ifront = i
			isentence += 1
	recover()

func print_atext() -> void:
	for child in get_children():
		remove_child(child)
	for word in atext:
		add_child(word)

func recover(is_atext_recovering :bool = false) -> void:
	if is_atext_recovering:
		atext.clear()
		if text.is_empty(): text = '{' + Word.FILL + '}'
		var connection := ''
		var iconnect := -1
		for islice in text.get_slice_count(' '):
			var slicer = text.get_slice(' ', islice)
			if iconnect == -1:
				if '{' in slicer:
					iconnect = islice
					connection = slicer.erase(slicer.find('{')) + ' '
				else:
					var aword = WORD.instantiate()
					aword.name = "word_{0}".format([islice])
					aword.text = text.get_slice(' ', islice)
					atext.append(aword)
			else:
				if '}' in slicer:
					var aword = WORD.instantiate()
					aword.name = "word_{0}".format([iconnect])
					aword.text = connection + slicer.erase(slicer.find('}'))
					atext.append(aword)
					iconnect = -1
					connection = ''
				else:
					connection += slicer + ' '
	else:
		var text_ = ''
		for word in get_children():
			if word is Word:
				text_ += word.text + ' '
		text_.erase(text_.length() - 1)
		text = text_
	print_atext()
	ftheme = ftheme
	fsize = fsize
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
	atext = from.atext
	indication.clear()
	selection.clear()
	is_active = false
	is_indication = false
	is_shift = false
	shift_word = null

func insert(what :Array[Word], after :Word = null, is_before :bool = false) -> void:
	if what.is_empty() or permission not in [FlowHandler.Permission.Write, FlowHandler.Permission.ReadAndWrite]: return
	if atext.front().text in [Word.EMPTY, Word.FILL] or atext.front()._text in [Word.EMPTY, Word.FILL]: atext.clear()
	if not after: after = atext.back()
	var pos = find(after)
	if !is_before: pos += 1
	if pos >= 0:
		for i in range(what.size()):
			var aword = WORD.instantiate()
			aword.name = "new_{0}".format([i])
			aword.copy(what[i])
			atext.insert(pos + i, aword)
	rename(what.front())
	recover()
func erase(what :Array[Word]) -> Array[Word]:
	var duplication = what
	for word in what:
		atext.erase(word)
	if atext.is_empty():
		var aword = WORD.instantiate()
		aword.name = "word_0"
		atext.insert(0, aword)
	else:
		rename(what[0])
	recover()
	return duplication

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

func is_empty() -> bool:
	return text in ['', '{' + Word.EMPTY + '}', '{' + Word.FILL + '}']


func sorting_by_name(a :Word, b :Word) -> bool:
	return a.name.get_slice('_', 1).to_int() < b.name.get_slice('_', 1).to_int()
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
	if not is_active: FlowHandler.switch_active(self)
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
	if selection.is_empty(): FlowHandler.switch_active()
	else:
		selection.filter(filtering_of_duplications)
		#print('\n  \tselection\t= ', selection.map(func(o): return o.name))
		for selected_word in selection:
			selected_word.select(true, false)

func _on_done() -> void: pass

