extends Character
class_name Enemy

var noise: OpenSimplexNoise
var attack: Attack
var forks := 1

onready var player = get_node("../Player")

func _init() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = 123
	noise.octaves = 5
	noise.period = 30000.0
	noise.persistence = 0.5
	attack = pick_attack()
	
func pick_attack() -> Attack:
	var attacks = [
		Burst.new(Bullet.Type.CURVE_LEFT, rand_range(-0.1, 0.1)),
		Burst.new(Bullet.Type.CURVE_RIGHT, rand_range(-0.1, 0.1)),
		Burst.new(Bullet.Type.NORMAL, 0.0, 10, 1.5),
		Burst.new(Bullet.Type.NORMAL, 0.0, 7, 1),
		Burst.new(Bullet.Type.SNAKE, rand_range(-0.1, 0.1), 5, 1.5),
		Burst.new(Bullet.Type.SNAKE_WIDE, rand_range(-0.1, 0.1), 10, 3.0)
	]
	
	var attack = attacks[randi() % attacks.size()] as Attack
	apply_stats_to(attack)
	
	return attack
	
func apply_stats_to(attack: Attack):
	attack.lifetime /= stats.fire_rate
	attack.lifetime_max /= stats.fire_rate
	
func seed_noise(s: int):
	noise.seed = s
	
func get_shot_angle() -> float:
	return body.rotation

func _process(delta):
	var direction = Vector2(cos(body.rotation), sin(body.rotation))
	velocity = max_speed * direction * 2 * stats.speed
	angle = noise.get_noise_2d(body.position.x, body.position.y) * 0.03 * stats.speed
	_move(delta)
	
	if player && body:
		var diff = player.body.position - body.position
		if !boss && abs(diff.length()) > 4000:
			stats.hp = 0
			
	if attack:
		attack._update(game, self, delta)
