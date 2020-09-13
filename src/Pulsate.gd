extends Node2D

export var speed := 1.0
export var amount := 0.1

var time := 0.0
var size := Vector2()

func _init() -> void:
	size = scale

func _process(delta: float) -> void:
	scale = size * (1.0 + amount * abs(sin(time)))
	time += delta * speed * 3.0
