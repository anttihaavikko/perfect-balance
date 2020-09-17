extends Node2D

onready var camera: Camera2D = get_node("../Camera")

func _process(delta: float) -> void:
	position = camera.position + camera.offset
	var res = Vector2(1024, 600)
#	position = res + camera.offset - camera.position / 5.0
