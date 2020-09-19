extends RigidBody2D

var will_teleport := false
var teleport_target := Vector2.ZERO

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if will_teleport:
		var t = state.get_transform()
		t.origin = teleport_target
		state.set_transform(t)
		will_teleport = false
	
func teleport(target: Vector2):
	teleport_target = target
	will_teleport = true
