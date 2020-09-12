extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

var tween: Tween
var duration: Timer
var frequency: Timer

onready var camera = get_parent()

func _ready() -> void:
	tween = Tween.new()
	duration = Timer.new()
	frequency = Timer.new()
	add_child(tween)
	add_child(duration)
	add_child(frequency)
	
	frequency.connect("timeout", self, "_new_shake")
	duration.connect("timeout", self, "_on_Duration_timeout")
	
func _on_Duration_timeout() -> void:
	_reset()
	frequency.stop()

func start(duration = 0.2, frequency = 15, amplitude = 16):
	if (priority >= self.priority):
		self.priority = amplitude
		self.amplitude = amplitude

		self.duration.wait_time = duration
		self.frequency.wait_time = 1 / float(frequency)
		self.duration.start()
		self.frequency.start()

		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)

	tween.interpolate_property(camera, "offset", camera.offset, rand, frequency.wait_time, TRANS, EASE)
	tween.start()

func _reset():
	tween.interpolate_property(camera, "offset", camera.offset, Vector2(), frequency.wait_time, TRANS, EASE)
	tween.start()

	priority = 0
