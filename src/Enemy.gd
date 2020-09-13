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
	
	return attacks[randi() % attacks.size()]
	
func seed_noise(s: int):
	noise.seed = s
	
func get_shot_angle() -> float:
	return body.rotation

func _process(delta):
	if !boss:
		var direction = Vector2(cos(body.rotation), sin(body.rotation))
		velocity = max_speed * direction
		angle = noise.get_noise_2d(body.position.x, body.position.y) * 0.015
		_move(delta)
	
	if player && body:
		var diff = player.body.position - body.position
		if !boss && abs(diff.length()) > 4000:
			hp = 0
			
	if attack:
		attack._update(game, self, delta)
