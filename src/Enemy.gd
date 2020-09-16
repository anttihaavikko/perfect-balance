extends Character
class_name Enemy

var noise: OpenSimplexNoise
var attack: Attack
var forks := 1
var lifetime := 0.0

var angle_offset := 0.0
var offset_calculated := false

onready var sprite = body.get_node("Sprite")
onready var player = get_node("../Player")

func _init() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = 123
	noise.octaves = 5
	noise.period = 50.0
	noise.persistence = 1.0
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
	return angle

func _process(delta):
	lifetime += delta
	var nv = noise.get_noise_1d(lifetime * 1.5 * stats.speed)
	angle = (nv + 1.0) * PI
	var tmp = angle
	angle += angle_offset
	
	if !offset_calculated:
		offset_calculated = true
		tmp = angle_offset
		angle_offset = angle
		angle = tmp
	
	var direction = Vector2(cos(angle), sin(angle))
	velocity = max_speed * direction * 2 * stats.speed
	sprite.rotation = angle + 0.5 * PI
	body.linear_velocity = velocity * 300 * delta * stats.speed
	
	if player && body:
		var diff = player.body.position - body.position
		if !boss && abs(diff.length()) > 4000:
			stats.hp = 0
			
	if attack:
		attack._update(game, self, delta)
