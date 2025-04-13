extends Label
class_name Word

#			Vars
var is_entered := false
var is_indicated := false
var is_selected := false

@onready var texter :Text = get_parent()


#			Funcs
func enter(is_enter :bool = true, is_notify :bool = true) -> bool:
	is_entered = is_enter
	if is_notify: texter.word_entered.emit(self, is_entered)
	if is_entered:
		add_theme_color_override('font_color', Color.BLACK)
		if is_indicated:
			add_theme_color_override('font_shadow_color', Color.YELLOW)
		elif is_selected:
			add_theme_color_override('font_shadow_color', Color.GREEN)
			mouse_default_cursor_shape = CURSOR_POINTING_HAND
		else:
			add_theme_color_override('font_shadow_color', Color.LIGHT_SKY_BLUE)
			mouse_default_cursor_shape = CURSOR_POINTING_HAND
		add_theme_constant_override('shadow_outline_size', 10)
	else:
		remove_theme_color_override('font_color')
		if is_indicated:
			add_theme_color_override('font_shadow_color', Color.ORANGE)
			add_theme_constant_override('shadow_outline_size', 10)
		elif is_selected:
			add_theme_color_override('font_shadow_color', Color.WEB_GREEN)
			add_theme_constant_override('shadow_outline_size', 10)
			mouse_default_cursor_shape = CURSOR_ARROW
		else:
			remove_theme_color_override('font_shadow_color')
			remove_theme_constant_override('shadow_outline_size')
			mouse_default_cursor_shape = CURSOR_ARROW
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
	if Input.is_action_just_released('alt-write'):
		texter.insert(FlowHandler.find_selection(), self, true)
	elif event.is_action_released('write'):
		texter.insert(FlowHandler.find_selection(), self)


func _on_mouse_entered() -> void:
	if not is_entered: enter()
func _on_mouse_exited() -> void:
	if not $Timer.is_stopped(): $Timer.stop()
	enter(false)

