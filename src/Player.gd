extends Character
class_name Player

onready var reticule: Node2D = $Reticule
onready var shoot_point: Node2D = $Torso/ShootPoint
onready var trail: Particles2D = $Torso/Trail
onready var hp_bar: ColorRect = get_node("../Canvas/HpBar/Border/Bg/Bar")
onready var hp_percent: Label = get_node("../Canvas/HpBar/Label")
onready var hp_tween: Tween = get_node("../Canvas/HpBar/Tween")

var noise: OpenSimplexNoise
var noise_offset := 0

func _init() -> void:
	self.stats.hp_max = 3
	self.stats.hp = 3
	noise = OpenSimplexNoise.new()
	noise.seed = 123
	noise.octaves = 5
	noise.period = 30000.0
	noise.persistence = 0.5

func _process(delta):	
	var shooting = Input.get_action_strength("shoot") > 0.5 && !picking_bonus
	var speed_mod = 0.5 if shooting else 1.0
	
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

func shoot(angle):
	shot_cooldown = shot_cooldown_max
	var b = Bullet.new(shoot_point.get_global_transform().get_origin(), angle, 6000 * stats.shot_speed, Color.white)
	b.is_enemy = false
	game.add_bullet(b)
	recoil()
	
func _update_hp():
	var percent = max(0, stats.hp / (stats.hp_max * 1.0))
	hp_percent.text = round(percent * 100) as String + " %"
	hp_tween.stop(hp_bar)
	hp_tween.interpolate_property(hp_bar, "rect_scale", Vector2(hp_bar.rect_scale.x, 1), Vector2(percent, 1), 0.15, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	hp_tween.start()
