extends Node

const PLANETS :Array[String] = ["Abyros", "Cryvolis", "Cyrathis", "Elyndra", "Ignarok", "Noxthetia", "Nyxar", "Scaeryn", "Sylvaris", "Velcrith", "Virellune", "Zarynth", "Zyphora"]
var DEFAULT_CLEAR_COLOR :Color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color")

var default_clear_color :Color:
	get: return RenderingServer.get_default_clear_color()
var tween :Tween


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		FlowHandler.save_docs()
		get_tree().quit()

func set_default_clear_color(color :Color = DEFAULT_CLEAR_COLOR) -> void:
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_method(RenderingServer.set_default_clear_color, default_clear_color, color, 1.4)

func doc_accept() -> void:
	var report = FlowHandler.ddocs[Interactor.Opject.table]["Report"].front()
	var article = FlowHandler.ddocs[Interactor.Opject.table]["Article"].front()
	if not report or not article: return
	if not article.is_empty():
		var is_accepted = article.analyze()
		Dialogic.VAR.set_variable("Is_accepted", is_accepted)
		Dialogic.start("Accept")
		await Dialogic.timeline_ended
		if is_accepted:
			report.update_resource()
			article.update_resource()
			SaveControl.save_resource_doc(article.resource)
			FlowHandler.move_doc(report, Interactor.Opject.locker_double)
			FlowHandler.move_doc(article, Interactor.Opject.locker)
			FlowHandler.display_docs()
	else:
		Dialogic.VAR.set_variable("Is_accepted", false)
		Dialogic.start("Accept")
		return

