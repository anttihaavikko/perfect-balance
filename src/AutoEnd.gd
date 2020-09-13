extends Particles2D

onready var game = get_node("../");

func _ready() -> void:
	emitting = true
	one_shot = true
	var timer = Timer.new()
	timer.wait_time = lifetime * 1.5
	add_child(timer)
	timer.connect("timeout", self, "die")
	
func die():
	queue_free()
