extends Character
class_name Enemy

var noise

func _init() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = 123
	noise.octaves = 4
	noise.period = 20000.0
	noise.persistence = 0.5
	
func seed_noise(s: int):
	noise.seed = s

func _process(delta):
	var direction = Vector2(cos(body.rotation), sin(body.rotation))
	velocity = max_speed * direction
	angle = noise.get_noise_2d(body.position.x, body.position.y) * 0.05
	_move(delta)

func shoot():
	var b = Bullet.new(body.position, body.rotation, 2000)
	game.add_bullet(b)

func _on_ShotTimer_timeout():
	shoot()
