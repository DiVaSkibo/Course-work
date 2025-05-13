extends Camera2D

const LIMIT_LEFT :Array[int] = [-900, -10000000]
const LIMIT_RIGHT :Array[int] = [900, 10000000]
const ZOOM :Array[Vector2] = [Vector2(1.2, 1.2), Vector2(.8, .8)]

var tween :Tween


func _zoom(is_out :bool = true):
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	var i = int(is_out)
	tween.tween_property(self, "zoom", ZOOM[i], .8)
	limit_left = LIMIT_LEFT[i]
	limit_right = LIMIT_RIGHT[i]

