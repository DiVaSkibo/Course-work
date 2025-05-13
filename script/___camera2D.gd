extends Camera2D

const ZOOM :Array[Vector2] = [Vector2(1.4, 1.4), Vector2(.7, .7)]
const LIMIT_LEFT :Array[int] = [-770, -1400]
const LIMIT_TOP :Array[int] = [-10000000, -220]
const LIMIT_RIGHT :Array[int] = [770, 1400]
const Y = 1000

var tween :Tween
var tween_default_clear_color :Tween
var is_default_clear_color := false


func _zoom(is_out :bool = true):
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	var i = int(is_out)
	tween.tween_property(self, "zoom", ZOOM[i], .8)
	limit_left = LIMIT_LEFT[i]
	limit_top = LIMIT_TOP[i]
	limit_right = LIMIT_RIGHT[i]

