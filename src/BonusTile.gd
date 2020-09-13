extends ColorRect

onready var game = get_node("../../../..");
onready var tween = $Tween

var picked := false

func _on_Button_mouse_entered() -> void:
	color = game.colors[0]
	tween.interpolate_property(self, "margin_top", 0, -50, 0.15, Tween.TRANS_BOUNCE)
	tween.start()

func _on_Button_mouse_exited() -> void:
	color = Color.white
	
	tween.interpolate_property(self, "margin_top", -50, 0, 0.15, Tween.TRANS_BOUNCE)
	tween.start()

func _on_Button_pressed() -> void:
	if !picked:
		game.pick_bonus(0)
	
func slide(delay: float):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.1, Tween.TRANS_BOUNCE)
	tween.interpolate_property(self, "margin_top", 300, 0, 0.3, Tween.TRANS_BOUNCE)
	tween.start()
	
func slide_and_free(delay: float):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.3, Tween.TRANS_BOUNCE)
	tween.interpolate_property(self, "margin_top", 0, 400, 0.3, Tween.TRANS_BOUNCE)
	tween.start()
	yield(get_tree().create_timer(5), "timeout")
	queue_free()
