extends ColorRect

onready var cam = get_node("../../Camera")

var prev := Vector2()

func _process(delta: float) -> void:
	var offset = (cam.offset + cam.position) * 0.0005
	var pos = Vector2(offset.x, -offset.y)
	material.set_shader_param("offset", pos)
