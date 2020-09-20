class_name Bullet

enum Type {
	NORMAL,
	CURVE_LEFT,
	CURVE_RIGHT,
	SNAKE,
	SNAKE_WIDE,
	ZIGZAG,
	HOMING
}

var position: Vector2
var prev_pos: Vector2
var angle: float
var speed: float
var is_enemy := true
var lifetime := 3.0
var damage := 1
var color: Color
var curve := 0.1
var type;
var phase := 0.0
var straighten := 0.0

func _init(position: Vector2, angle: float, speed: float, color: Color):
	self.position = position
	self.prev_pos = position
	self.angle = angle
	self.speed = speed
	self.color = color

func update(delta, target) -> bool:
	prev_pos = position
	position += Vector2(cos(angle), sin(angle)) * speed * delta;
	lifetime -= delta
	phase += delta * 10
	
	if straighten > 0 && phase * 0.1 > straighten:
		type = Type.NORMAL
	
	if(type == Type.CURVE_LEFT):
		angle -= curve;
		
	if(type == Type.CURVE_RIGHT):
		angle += curve;
		
	if type == Type.HOMING:
		var diff = position.angle_to_point(target.body.position)
		var dir = 1 if diff > 0 else -1
		angle += curve * dir
		
	if(type == Type.SNAKE):
		angle += curve * sign(sin(phase));
		
	if(type == Type.SNAKE_WIDE):
		angle += curve * sign(sin(phase)) * 0.5;
	
	return lifetime > 0
