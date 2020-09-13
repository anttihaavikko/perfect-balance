extends Node2D

var tween: Tween;

func _init() -> void:
	tween = Tween.new()
	add_child(tween)
	
func appear():
	tween.interpolate_property(self, "scale", Vector2(), Vector2.ONE, 0.3, Tween.TRANS_BOUNCE)
	tween.start()
	
func disappear():
	tween.interpolate_property(self, "scale", Vector2.ONE, Vector2(), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
