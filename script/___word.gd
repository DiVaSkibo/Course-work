extends Label
class_name Word

#			Vars
enum State {entered, indicated, selected}

const EMPTY :String = "_"
const FILL :String = "fill it..."
const COLORS :String = "     :      "
const SHADOW_COLOR :Dictionary = {
	State.entered: [Color.BLACK, Color("B2FFFF")],
	State.indicated: [Color("FFFFB2"), Color("FFFF66")],
	State.selected: [Color("B2FFB2"), Color("66FF66")]
}

var _text :String = text
var code :Array = [null, null]
var is_code := false:
	set(value):
		$ColorRect0.visible = value
		$ColorRect1.visible = value
	get:
		return $ColorRect0.visible and $ColorRect1.visible
var is_entered := false
var is_indicated := false
var is_selected := false

@onready var texter :Text = get_parent()


#			Funcs
func _ready():
	if text.is_empty():
		text = EMPTY

func encode() -> void:
	_text = text
	if code[0] is Color:
		text = COLORS
		is_code = true
		$ColorRect0.color = code[0]
		$ColorRect1.color = code[1]
	else: text = '{0}:{1}'.format(code)
func decode() -> void:
	text = _text
	if code[0] is Color:
		is_code = false

func copy(from :Word) -> void:
	text = from.text
	_text = from._text
	code = from.code
	if code[0] is Color:
		$ColorRect0.color = code[0]
		$ColorRect1.color = code[1]
	is_code = from.is_code


func enter(is_enter :bool = true, is_notify :bool = true) -> bool:
	is_entered = is_enter
	if is_notify: texter.word_entered.emit(self, is_entered)
	add_theme_color_override('font_color', Color.BLACK)
	if is_entered:
		if is_indicated:
			add_theme_color_override('font_shadow_color', SHADOW_COLOR[State.indicated][1])
		elif is_selected:
			add_theme_color_override('font_shadow_color', SHADOW_COLOR[State.selected][1])
			mouse_default_cursor_shape = CURSOR_POINTING_HAND
		else:
			add_theme_color_override('font_shadow_color', SHADOW_COLOR[State.entered][1])
			mouse_default_cursor_shape = CURSOR_POINTING_HAND
		add_theme_constant_override('shadow_outline_size', 10)
	else:
		if is_indicated:
			add_theme_color_override('font_shadow_color', SHADOW_COLOR[State.indicated][0])
			add_theme_constant_override('shadow_outline_size', 10)
		elif is_selected:
			add_theme_color_override('font_shadow_color', SHADOW_COLOR[State.selected][0])
			add_theme_constant_override('shadow_outline_size', 10)
			mouse_default_cursor_shape = CURSOR_ARROW
		else:
			remove_theme_color_override('font_shadow_color')
			remove_theme_constant_override('shadow_outline_size')
			mouse_default_cursor_shape = CURSOR_ARROW
			remove_theme_color_override('font_color')
	return is_entered

func indicate(is_indicate :bool = true, is_notify :bool = true) -> bool:
	is_indicated = is_indicate
	if is_notify: texter.word_indicated.emit(self, is_indicated)
	mouse_default_cursor_shape = CURSOR_IBEAM
	enter(is_entered, false)
	return is_indicated

func select(is_select :bool = true, is_notify :bool = true) -> bool:
	is_selected = is_select
	is_indicated = false
	if is_notify: texter.word_selected.emit(self, is_selected)
	enter(is_entered, false)
	return is_selected


#			Signals
func _on_gui_input(event: InputEvent) -> void:
	if text not in [EMPTY, FILL]:
		if Input.is_action_just_released('shift-selection'):
			if is_entered or is_indicated:
				texter.word_selected.emit(self, not is_selected)
				$Timer.stop()
		elif event.is_action_released('selection'):
			if is_entered or is_indicated:
				texter.word_selected.emit(self, not is_selected)
				$Timer.stop()
		elif event.is_action_pressed('selection'):
			if $Timer.is_stopped():
				$Timer.start()
			await $Timer.timeout
			texter.is_shift = event.is_action_pressed('shift-selection')
			texter.word_indicated.emit(self)
	if Input.is_action_just_released('ctrl-write'):
		FlowHandler.insert_selection(texter, self, true)
	elif event.is_action_released('write'):
		FlowHandler.insert_selection(texter, self)


func _on_mouse_entered() -> void:
	if not is_entered: enter()
func _on_mouse_exited() -> void:
	if not $Timer.is_stopped(): $Timer.stop()
	enter(false)

