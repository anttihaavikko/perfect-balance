extends Attack
class_name Burst

var type;

func _init(type, curve = 0.0, shots = 5, lifetime = 1.0) -> void:
	self.shots = shots
	self.lifetime = lifetime
	self.type = type
	self.curve = curve

func _shoot(game: Node2D, enemy, angle: float, delta: float):
	var offset = Vector2(cos(enemy.body.rotation + angle), sin(enemy.body.rotation + angle))
	var b = Bullet.new(enemy.body.position + offset * enemy.hitbox_radius, enemy.body.rotation + angle, 2000, enemy.color)
	prepare_bullet(b)
	game.add_bullet(b)
