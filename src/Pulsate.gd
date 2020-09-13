extends Node2D

export var speed := 1.0
export var amount := 0.1
export var freeze_x := false
export var freeze_y := false

var time := 0.0
var size := Vector2()

func _init() -> void:
	size = scale

func _process(delta: float) -> void:
	var s = size * (1.0 + amount * abs(sin(time)))
	if freeze_x:
		scale = Vector2(scale.x, s.y)
	elif freeze_y:
		scale = Vector2(s.x, scale.y)
	else:
		scale = s
	time += delta * speed * 3.0
