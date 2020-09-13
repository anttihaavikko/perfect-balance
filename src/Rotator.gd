extends Node2D

export var speed := 1.0

func _process(delta: float) -> void:
	rotate(speed * delta)
