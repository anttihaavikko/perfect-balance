class_name Attack

var lifetime := 1.0
var shots = 5

var next := 0.0
var shot_count := 0
var curve := 0.0

func _init() -> void:
	next = lifetime - lifetime / shots
	
func _update(game: Node2D, enemy, delta: float):
	if(lifetime > 0):
		lifetime -= delta
	
	if lifetime <= next && shot_count < shots:
		shot_count += 1
		next -= lifetime / shots if lifetime > 0 else 999
		for i in range(enemy.forks):
			var angle = 2 * PI / enemy.forks * i
			_shoot(game, enemy, angle, delta)
		
func prepare_bullet(b: Bullet):
	b.type = self.type
	b.curve = self.curve
		
func is_done() -> bool:
	return lifetime <= 0
	
func _shoot(game: Node2D, enemy, angle: float, delta: float):
	pass
