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
	var pos = body.position - cam.position
	var angle_to_mouse = pos.angle_to_point(mouse) - PI * 0.5
	var distance_to_mouse = min(body.position.distance_to(mouse), 100.0)
	
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
		shoot(pos.angle_to_point(mouse) + PI)
		
	_move(delta)
	
	var dir = Vector2(cos(angle_to_mouse), sin(angle_to_mouse))
	var repos = body.position + dir * distance_to_mouse - cam.position
	var repos_velo = repos * 10.0 * delta
	
	cam.position += repos_velo

func shoot(angle):
	shot_cooldown = shot_cooldown_max
	var b = Bullet.new(body.position, angle, 5000)
	b.is_enemy = false
	game.add_bullet(b)
	recoil()
