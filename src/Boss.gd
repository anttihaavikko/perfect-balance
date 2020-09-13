extends Enemy
class_name Boss

var cached_angle = 0.0

func pick_attack() -> Attack:
	var spins = randi() % 3
	var attacks = [
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0, 2 * PI),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0, 2 * PI),
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0, 4 * PI),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0, 4 * PI),
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0),
		Spread.new([
			Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0, spins * PI)
		], 0.1),
		Spread.new([
			Burst.new(Bullet.Type.CURVE_RIGHT, 0.005, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.CURVE_LEFT, 0.005, 25, 3.0, spins * PI)
		], 0.2),
		Spread.new([
			Burst.new(Bullet.Type.SNAKE, 0.04, 10, 4.0),
			Burst.new(Bullet.Type.SNAKE, 0.04, 30, 5.0),
			Burst.new(Bullet.Type.SNAKE, -0.04, 30, 5.0),
			Burst.new(Bullet.Type.SNAKE, -0.04, 10, 4.0)
		], 0.3),		
		Spread.new([
			Burst.new(Bullet.Type.NORMAL, 0.0, 10, 4.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 20, 5.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 20, 5.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 10, 4.0, spins * PI)
		], 0.6),		
	]
	
	calculate_angle()
	
	return attacks[randi() % attacks.size()]
	
func get_shot_angle() -> float:
	return cached_angle
	
func calculate_angle():
	if !player:
		return
		
	cached_angle = body.position.angle_to_point(player.body.position) + PI

func _process(delta: float) -> void:
	if attack:
		if attack.is_done():
			yield(get_tree().create_timer(1.0), "timeout")
			attack = pick_attack()
