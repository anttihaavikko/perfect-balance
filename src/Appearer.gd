extends Node2D

var tween: Tween;

func _init() -> void:
	tween = Tween.new()
	add_child(tween)
	
func appear():
	Quick.tween_show(self, 0.3)
	
func disappear():
	Quick.tween_hide(self, 0.3)
