extends Character
class_name Player

onready var reticule: Node2D = $Reticule
onready var shoot_point: Node2D = $Torso/ShootPoint
onready var trail: Particles2D = $Torso/Trail
onready var hp_bar: ColorRect = get_node("../Canvas/HpBar/Border/Bg/Bar")
onready var hp_percent: Label = get_node("../Canvas/HpBar/Label")
onready var hp_tween: Tween = get_node("../Canvas/HpBar/Tween")

onready var head: RigidBody2D = get_node("Head")
onready var calf1: RigidBody2D = get_node("Limb Upper")
onready var calf2: RigidBody2D = get_node("Limb Upper2")
onready var limb1: RigidBody2D = get_node("Limb Lower")
onready var limb2: RigidBody2D = get_node("Limb Lower2")
onready var limb3: RigidBody2D = get_node("Limb Lower3")
onready var limb4: RigidBody2D = get_node("Limb Lower4")

onready var shot_particles = get_node("Torso/ShootPoint/ShotParticles")
onready var muzzle_flash = get_node("Torso/ShootPoint/MuzzleFlash")

onready var drone = preload("res://src/Drone.tscn")

var noise: OpenSimplexNoise
var noise_offset := 0
var drones = []

var move_shown := false
var aim_shown := false
var move_done := false
var aim_done := false

func _init() -> void:
	self.stats.hp_max = 5
	self.stats.hp = 5
	noise = OpenSimplexNoise.new()
	noise.seed = 123
	noise.octaves = 5
	noise.period = 30000.0
	noise.persistence = 0.5
	scores = false

func _process(delta):
	if is_dead:
		return
		
	var shooting = Input.get_action_strength("shoot") > 0.5 && !picking_bonus
	var speed_mod = 0.5 if shooting else 1.0
	
	for d in drones:
		var mod = 1.5 if picking_bonus else 1.0
		d.follow(stats.speed * speed_mod * mod, delta)
	
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var direction := Vector2(x, y)
	
	if direction.length() > 1:
		direction = direction.normalized()
	
	velocity = direction * max_speed * speed_mod
	
	if picking_bonus:
		noise_offset += delta * 100
		velocity = Vector2(noise.get_noise_1d(noise_offset) * 2, -1) * max_speed
		
	trail.emitting = velocity.length() > 0.5
	
	var res = Vector2(1024, 600)
	var mouse = get_viewport().get_mouse_position() * 5 - 2.5 * res
	var pos = body.position - cam.position
	var angle_to_mouse = pos.angle_to_point(mouse) - PI * 0.5
	var distance_to_mouse = min(body.position.distance_to(mouse), 100.0)
	
	reticule.position = mouse + cam.position
	
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
	
	if body.position.length() > 500:
		if !move_done:
			game.tutorial_move_timer.stop()
			if move_shown:
				Quick.tween_hide(game.tutorial_move)
			if !aim_done:
				game.tutorial_aim_timer.start()
		move_done = true

func shoot(angle):
	
	if !aim_done:
		game.can_spawn = true
		game.spawner.start_timer.start()
		aim_done = true
		game.tutorial_aim_timer.stop()
		if aim_shown:
			Quick.tween_hide(game.tutorial_aim)
	
	AudioManager.add(11, body.position, 0.700000)
	AudioManager.add(2, body.position, 1.000000)
	AudioManager.add(28, body.position, 1.2500000)

	shockwave.boom(muzzle_flash.position)
	shot_particles.emitting = true
	muzzle_flash.emitting = true
	shot_cooldown = shot_cooldown_max
	
	add_bullet(shoot_point.get_global_transform().get_origin(), angle)
	
	for d in drones:
		add_bullet(d.position, angle)
		
	var dir = Vector2(cos(angle), sin(angle))
	head.apply_central_impulse(dir * 2000.0)
	limb4.apply_central_impulse(-dir * 1000.0)
	limb3.apply_central_impulse(-dir * 1000.0)
	limb2.apply_central_impulse(-dir * 1000.0)
	limb1.apply_central_impulse(-dir * 1000.0)
	calf1.apply_torque_impulse(60000.0)
	calf2.apply_torque_impulse(-60000.0)
	recoil()

func add_bullet(pos: Vector2, angle: float):
	var b = Bullet.new(pos, angle, 6000 * stats.shot_speed, Color.white)
	b.lifetime *= stats.shot_range * 0.15
	b.damage = stats.damage
	b.is_enemy = false
	game.add_bullet(b)
	
func _update_hp():
	var percent = max(0, stats.hp / (stats.hp_max * 1.0))
	hp_percent.text = "%d / %d" % [stats.hp, stats.hp_max]
	hp_tween.stop(hp_bar)
	hp_tween.interpolate_property(hp_bar, "rect_scale", Vector2(hp_bar.rect_scale.x, 1), Vector2(percent, 1), 0.15, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	hp_tween.start()

func heal():
	stats.hp = min(stats.hp_max, stats.hp + 1)
	
	AudioManager.add(6, body.position, 1.000000)
	AudioManager.add(7, body.position, 1.000000)
	AudioManager.add(12, body.position, 1.000000)

	_update_hp()
	flash(1)
	
func add_drone():
	var d = drone.instance()
	game.add_child(d)
	d.position = body.position
	drones.append(d)
	
func _took_damage():
	game.score.reset_multi()
	
func _died():
	game.game_over()
