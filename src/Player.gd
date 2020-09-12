extends Character
class_name Player

onready var reticule: Node2D = $Reticule

func _process(delta):
	var shooting = Input.get_action_strength("shoot") > 0.5
	var speed_mod = 0.5 if shooting else 1.0
	
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var direction := Vector2(x, y)
	
	if direction.length() > 1:
		direction = direction.normalized()
	
	velocity = direction * max_speed * speed_mod
	
	var mouse = get_viewport().get_mouse_position() * 5 - 2.5 * get_viewport().size
	var angle_to_mouse = body.position.angle_to_point(mouse) - PI * 0.5
	
	reticule.position = mouse
	
	while body.rotation - angle_to_mouse > PI:
		angle_to_mouse += PI
		
	while body.rotation - angle_to_mouse < -PI:
		angle_to_mouse -= PI
	
	if abs(angle_to_mouse - body.rotation) > 0.4:
		angle = 0.2 * sign(angle_to_mouse - body.rotation)
	else:
		angle = 0
		
	if shooting && shot_cooldown <= 0:
		shoot(body.position.angle_to_point(mouse) + PI)
		
	_move(delta)

func shoot(angle):
	shot_cooldown = shot_cooldown_max
	var b = Bullet.new(body.position, angle, 5000)
	b.is_enemy = false
	game.add_bullet(b)
	recoil()
