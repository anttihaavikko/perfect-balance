extends ColorRect

export var speed := 1.0
export var amount := 0.1
export var freeze_x := false
export var freeze_y := false

var time := 0.0
var size := Vector2()

func _init() -> void:
	size = rect_scale

func _process(delta: float) -> void:
	var s = size * (1.0 + amount * abs(sin(time)))
	if freeze_x:
		rect_scale = Vector2(rect_scale.x, s.y)
	elif freeze_y:
		rect_scale = Vector2(s.x, rect_scale.y)
	else:
		rect_scale = s
	time += delta * speed * 3.0
