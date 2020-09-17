extends Node

var tweener: Tween

func _ready() -> void:
	tweener = Tween.new()
	add_child(tweener)

func tween(object, property: String, from, to, duration: float, easing := Tween.TRANS_BOUNCE, ease_in := false, ease_out := true):
	var ease_dir = Tween.EASE_OUT
	if ease_in && ease_out:
		Tween.EASE_IN_OUT
	elif ease_in:
		Tween.EASE_IN
	tweener.interpolate_property(object, property, from, to, duration, easing, ease_dir)
	
