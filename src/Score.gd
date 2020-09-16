extends ColorRect

onready var total: Label = $Total
onready var multiplier: Label = $Multiplier
onready var latest: Label = $Latest
onready var tween: Tween = $Tween
onready var timer: Timer = $Timer

var score := 0
var multi := 1

func add(amount: int):
	latest.text = "+" + amount as String
	timer.stop()
	timer.start()
	tween.stop(self, "score")
	tween.interpolate_property(self, "score", score, score + amount * multi, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	score += amount * multi
	
func add_multi(amount: int = 1):
	multi += amount
	update_multi()
	
func reset_multi():
	multi = 1
	update_multi()
	
func update_multi():
	multiplier.text = "x" + multi as String
	
func _process(delta: float) -> void:
	total.text = score as String

func _on_Timer_timeout() -> void:
	latest.text = ""
