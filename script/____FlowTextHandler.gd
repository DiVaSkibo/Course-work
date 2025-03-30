extends Node

#			Vars
var dtexts :Dictionary = {
	Text.Permission.Read: [],
	Text.Permission.Write: [],
	Text.Permission.ReadAndWrite: []
}


#			Funcs
func analyze(scene :Node) -> void:
	for text in scene.get_children():
		if text is Text:
			dtexts[text.permission].append(text)

func switch(text :Text) -> bool:
	var text_active = find(Text.Permission.none, [text])
	if not text_active: return false
	text_active.deactivate.emit()
	return true

func find(permission :Text.Permission = Text.Permission.none, skip :Array[Text] = []) -> Text:
	if permission == Text.Permission.none:
		for permiss in dtexts.keys():
			var text = find(permiss, skip)
			if text: return text
		return null
	for text in dtexts[permission]:
		if text.is_active and text not in skip:
			return text
	return null
func find_selection(permission :Text.Permission = Text.Permission.none) -> Array[Word]:
	return find(permission).selection

