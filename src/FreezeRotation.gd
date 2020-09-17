extends Node2D

onready var parent = get_node("..")

func _process(delta: float) -> void:
	rotation = -parent.rotation

