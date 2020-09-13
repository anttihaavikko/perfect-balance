class_name Attack

var lifetime := 1.0

func _init() -> void:
	pass
	
func _update(delta):
	if(lifetime > 0):
		lifetime -= delta
		
func is_done() -> bool:
	return lifetime <= 0
