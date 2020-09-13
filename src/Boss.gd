extends Enemy
class_name Boss

func pick_attack() -> Attack:
	var attacks = [
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0, 2 * PI),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0, 2 * PI),
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0, 4 * PI),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0, 4 * PI),
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0)
	]
	
	return attacks[randi() % attacks.size()]

func _process(delta: float) -> void:
	if attack:
		if attack.is_done():
			yield(get_tree().create_timer(1.0), "timeout")
			attack = pick_attack()
