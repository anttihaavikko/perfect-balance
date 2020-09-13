extends Character
class_name Enemy

var noise: OpenSimplexNoise
var color: Color

onready var player = get_node("../Player")

func _init() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = 123
	noise.octaves = 5
	noise.period = 30000.0
	noise.persistence = 0.5
	
func colorize(color: Color):
	self.color = color
	#modulate = color
	
func seed_noise(s: int):
	noise.seed = s

func _process(delta):
	var direction = Vector2(cos(body.rotation), sin(body.rotation))
	velocity = max_speed * direction
	angle = noise.get_noise_2d(body.position.x, body.position.y) * 0.03
	_move(delta)
	
	if player && body:
		var diff = player.body.position - body.position
		if abs(diff.length()) > 4000:
			hp = 0

func shoot():
	var b = Bullet.new(body.position, body.rotation, 2000, color)
	game.add_bullet(b)

func _on_ShotTimer_timeout():
	shoot()
