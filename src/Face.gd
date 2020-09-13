extends Node2D

onready var eye_left = $Eyes/EyeLeft
onready var eye_right = $Eyes/EyeRight

var tween: Tween
var eye_size: Vector2
var closed: float

func _ready() -> void:
	eye_size = eye_left.scale
	closed = eye_size.y * 0.5
	tween = Tween.new()
	add_child(tween)
	blink()
	
func blink():
	var delay = rand_range(2, 7)
	var diff = rand_range(-0.15, 0.15)

	blink_eye(eye_left, delay)
	blink_eye(eye_right, delay + diff)
	
	yield(get_tree().create_timer(delay + 0.5), "timeout")
	blink()
	
	
func blink_eye(eye: Node2D, delay: float):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(eye, "scale", eye_size, Vector2(eye_size.x, closed), 0.25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.25), "timeout")
	tween.interpolate_property(eye, "scale", Vector2(eye_size.x, closed), eye_size, 0.25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
