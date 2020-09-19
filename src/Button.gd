extends ColorRect

const angle_limit = 10.0
const hover_size = 1.2

export var text: String
export var scene_to_load: String

var original_scale: Vector2

signal clicked

func _ready() -> void:
	$Text.text = text
	original_scale = rect_scale

func _on_ClickArea_pressed() -> void:
	if scene_to_load:
		TransitionScreen.close()
		yield(get_tree().create_timer(TransitionScreen.transition_time), "timeout")
		get_tree().change_scene("res://src/%s.tscn" % scene_to_load)
	else:
		emit_signal("clicked")

func _on_ClickArea_mouse_entered() -> void:
	color = Stuff.colors[0]
	Quick.tween(self, "rect_scale", rect_scale, original_scale * hover_size, 0.2)


func _on_ClickArea_mouse_exited() -> void:
	color = Color.white
	Quick.tween(self, "rect_scale", rect_scale, original_scale, 0.1)
