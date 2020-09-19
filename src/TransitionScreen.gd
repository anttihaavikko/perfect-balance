extends CanvasLayer

onready var door1 = $ColorRect1
onready var door2 = $ColorRect2
onready var door3 = $ColorRect3
onready var door4 = $ColorRect4

var transition_time := 0.75

func open():
	Quick.tween(door1, "rect_scale", Vector2(1, 1), Vector2(0, 1), transition_time)
	Quick.tween(door2, "rect_scale", Vector2(1, 1), Vector2(0, 1), transition_time)
	Quick.tween(door3, "rect_scale", Vector2(1, 1), Vector2(0, 1), transition_time)
	Quick.tween(door4, "rect_scale", Vector2(1, 1), Vector2(0, 1), transition_time)
	
func close():
	Quick.tween(door1, "rect_scale", Vector2(0, 1), Vector2(1, 1), transition_time)
	Quick.tween(door2, "rect_scale", Vector2(0, 1), Vector2(1, 1), transition_time)
	Quick.tween(door3, "rect_scale", Vector2(0, 1), Vector2(1, 1), transition_time)
	Quick.tween(door4, "rect_scale", Vector2(0, 1), Vector2(1, 1), transition_time)
