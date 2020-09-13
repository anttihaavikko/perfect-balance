extends ColorRect

onready var cam = get_node("../../Camera")

func _process(delta: float) -> void:
	var offset = (cam.offset + cam.position) * 0.0005
	material.set_shader_param("offset", Vector2(offset.x, -offset.y))
