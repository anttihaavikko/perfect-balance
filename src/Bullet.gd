class_name Bullet

var position: Vector2
var angle: float
var speed: float
var is_enemy := true
var lifetime := 3.0
var damage := 1
var color: Color

func _init(position: Vector2, angle: float, speed: float, color: Color):
	self.position = position
	self.angle = angle
	self.speed = speed
	self.color = color

func update(delta) -> bool:
	position += Vector2(cos(angle), sin(angle)) * speed * delta;
	lifetime -= delta
	return lifetime > 0
