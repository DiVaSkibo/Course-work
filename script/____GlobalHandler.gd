extends Node

var DEFAULT_CLEAR_COLOR :Color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color")
var default_clear_color :Color:
	set(value): RenderingServer.set_default_clear_color(value)
	get: return RenderingServer.get_default_clear_color()
var tween :Tween


func set_default_clear_color(color :Color = DEFAULT_CLEAR_COLOR) -> void:
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_method(RenderingServer.set_default_clear_color, default_clear_color, color, 1.4)

