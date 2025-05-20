extends VBoxContainer

#			Vars
@onready var button_accept :Button = $ButtonAccept
@onready var menu_create :MenuButton = $MenuCreate
@onready var menu_graphic :MenuButton = $MenuGraphic
@onready var menu_audio :MenuButton = $MenuAudio


#			Funcs
func _ready() -> void:
	hide()
	menu_create.get_popup().id_pressed.connect(_on_menu_create_pressed)
	menu_graphic.get_popup().id_pressed.connect(_on_menu_graphic_pressed)
	menu_audio.get_popup().id_pressed.connect(_on_menu_audio_pressed)
func _input(event :InputEvent) -> void:
	if event.is_action_pressed("selection") or event.is_action_released("setting"):
		if visible: display(false)
		else:
			global_position = get_global_mouse_position()
			if not visible: display()
	elif event is not InputEventMouseMotion and event.is_action_pressed("selection") and event.is_action_released("selection"):
		if visible: display(false)

func display(is_displaying :bool = true) -> void:
	visible = is_displaying
	button_accept.visible = is_displaying
	menu_create.visible = is_displaying
	menu_graphic.visible = is_displaying
	menu_audio.visible = is_displaying


#			Signals
func _on_button_accept_button_up() -> void:
	print("||")
	display(false)
func _on_menu_create_pressed(id: int) -> void:
	match id:
		0: FlowHandler.create_doc("Report")
		1: FlowHandler.create_doc("Article")
	display(false)
func _on_menu_graphic_pressed(id: int) -> void:
	if not menu_graphic.get_popup().is_item_checked(id):
		var value
		match id:
			0: value = RenderingServer.VIEWPORT_MSAA_4X
			1: value = RenderingServer.VIEWPORT_MSAA_DISABLED
		RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), value)
		for i in range(menu_graphic.item_count):
			menu_graphic.get_popup().set_item_checked(i, false)
		menu_graphic.get_popup().set_item_checked(id, true)
		SaveControl.save_config(SaveControl.Sphere.global, "Setting", "Graphic", value)
func _on_menu_audio_pressed(id: int) -> void:
	if not menu_audio.get_popup().is_item_checked(id):
		var value
		match id:
			0: value = .2
			1: value = .1
			2: value = .05
			3: value = .0
		AudioServer.set_bus_volume_linear(0, value)
		for i in range(menu_audio.item_count):
			menu_audio.get_popup().set_item_checked(i, false)
		menu_audio.get_popup().set_item_checked(id, true)
		SaveControl.save_config(SaveControl.Sphere.global, "Setting", "Audio", value)

