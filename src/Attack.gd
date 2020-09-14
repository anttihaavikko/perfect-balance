class_name Attack

var lifetime := 1.0
var shots = 5

var next := 0.0
var shot_count := 0
var curve := 0.0
var spin := 0.0
var lifetime_max := 0.0
var straighten := 0.0

var color: Color

func _init() -> void:
	prepare_next()
	
func prepare_next():
	next = lifetime - lifetime / shots
	lifetime_max = lifetime
	
func _update(game: Node2D, enemy, delta: float):
	if(lifetime > 0):
		lifetime -= delta
	
	if lifetime <= next && shot_count < shots:
		shot_count += 1
		next -= lifetime / shots if lifetime > 0 else 999
		var percent = 1.0 - lifetime / lifetime_max
		for i in range(enemy.forks):
			var angle = 2 * PI / enemy.forks * i + percent * spin
			_shoot(game, enemy, angle, delta)
		
func prepare_bullet(b: Bullet):
	b.type = self.type
	b.curve = self.curve
	b.straighten = self.straighten
	b.color = self.color
		
func is_done() -> bool:
	return lifetime <= 0
	
func _shoot(game: Node2D, enemy, angle: float, delta: float):
	pass
