extends ColorRect

const angle_limit = 10.0
const hover_size = 1.2

func _on_ClickArea_pressed() -> void:
	get_tree().change_scene("res://src/Game.tscn")


func _on_ClickArea_mouse_entered() -> void:
	color = Stuff.colors[0]
	Quick.tween(self, "rect_scale", Vector2.ONE, Vector2.ONE * hover_size, 0.2)


func _on_ClickArea_mouse_exited() -> void:
	color = Color.white
	Quick.tween(self, "rect_scale", Vector2.ONE * hover_size, Vector2.ONE, 0.1)
