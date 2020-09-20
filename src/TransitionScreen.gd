extends CanvasLayer

onready var door1 = $ColorRect1
onready var door2 = $ColorRect2
onready var door3 = $ColorRect3
onready var door4 = $ColorRect4

var transition_time := 0.75

func open():
	sound()
	Quick.tween(door1, "rect_scale", Vector2(1, 1), Vector2(0, 1), transition_time)
	Quick.tween(door2, "rect_scale", Vector2(1, 1), Vector2(0, 1), transition_time)
	Quick.tween(door3, "rect_scale", Vector2(1, 1), Vector2(0, 1), transition_time)
	Quick.tween(door4, "rect_scale", Vector2(1, 1), Vector2(0, 1), transition_time)
	
func close():
	sound()
	Quick.tween(door1, "rect_scale", Vector2(0, 1), Vector2(1, 1), transition_time)
	Quick.tween(door2, "rect_scale", Vector2(0, 1), Vector2(1, 1), transition_time)
	Quick.tween(door3, "rect_scale", Vector2(0, 1), Vector2(1, 1), transition_time)
	Quick.tween(door4, "rect_scale", Vector2(0, 1), Vector2(1, 1), transition_time)
	
func sound():
	AudioManager.add(16, Vector2(512, 300), 0.600000)
	AudioManager.add(15, Vector2(512, 300), 1.000000)
	AudioManager.add(17, Vector2(512, 300), 0.000000)
	AudioManager.add(14, Vector2(512, 300), 0.500000)

