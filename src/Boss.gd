extends Enemy
class_name Boss

onready var face = $Torso/Face
onready var enrage_timer = $Timer
onready var teleport_marker = $TeleportMarker
onready var boss_body = $Torso

var cached_angle = 0.0
var mid: Vector2
var face_tween: Tween

func _ready() -> void:
	face_tween = Tween.new()
	add_child(face_tween)
	
	teleport_marker.scale = Vector2.ZERO
	
	if face:
		mid = face.position
		move_face(get_face_pos())

func get_face_pos() -> Vector2:
	if !player:
		return Vector2()
		
	var angle = body.position.angle_to_point(player.body.position) + PI
	return Vector2(cos(angle), sin(angle)) * 120

func pick_attack() -> Attack:
	var spins = randi() % 3
	var delay = rand_range(0.5, 1.5)
	var mod = 1.0 if randi() % 2 == 0 else -1.0
	
	var attacks = [
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0, 2 * PI),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0, 2 * PI),
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0, 4 * PI),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0, 4 * PI),
		Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0),
		Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0),
		Spread.new([
			Burst.new(Bullet.Type.CURVE_LEFT, 0.015, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.CURVE_RIGHT, 0.015, 25, 3.0, spins * PI)
		], 0.1),
		Spread.new([
			Burst.new(Bullet.Type.CURVE_RIGHT, 0.005, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 25, 3.0, spins * PI),
			Burst.new(Bullet.Type.CURVE_LEFT, 0.005, 25, 3.0, spins * PI)
		], 0.2),
		Spread.new([
			Burst.new(Bullet.Type.SNAKE, 0.04, 10, 4.0),
			Burst.new(Bullet.Type.SNAKE, 0.04, 30, 5.0),
			Burst.new(Bullet.Type.SNAKE, -0.04, 30, 5.0),
			Burst.new(Bullet.Type.SNAKE, -0.04, 10, 4.0)
		], 0.3),		
		Spread.new([
			Burst.new(Bullet.Type.NORMAL, 0.0, 10, 4.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 20, 5.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 20, 5.0, spins * PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 10, 4.0, spins * PI)
		], 0.6),	
		Spread.new([
			Burst.new(Bullet.Type.NORMAL, 0.0, 25, 3.0, (spins + 1) * -PI),
			Burst.new(Bullet.Type.NORMAL, 0.0, 25, 3.0, (spins + 1) * PI)
		], 0.4),	
		Spread.new([
			Burst.new(Bullet.Type.CURVE_LEFT, mod * 0.1, 25, 3.0, 0.5 * PI, delay),
			Burst.new(Bullet.Type.CURVE_LEFT, mod * 0.1, 25, 3.0, 1.0 * PI, delay),
			Burst.new(Bullet.Type.CURVE_LEFT, mod * 0.1, 25, 3.0, 1.5 * PI, delay)
		], 0.4),	
	]
	
	var attack = attacks[randi() % attacks.size()] as Attack
	
	calculate_angle()
	apply_stats_to(attack)
	
	return attack
	
func get_shot_angle() -> float:
	return cached_angle
	
func calculate_angle():
	if !player:
		return
		
	cached_angle = body.position.angle_to_point(player.body.position) + PI
	
func move_face(pos: Vector2):
	if face:
		face_tween.stop_all()
		face_tween.interpolate_property(face, "position", face.position, pos, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		face_tween.start()

func _process(delta: float) -> void:
	if player && player.body && body:
		var distance = (body.position - player.body.position).length()
		var angle = body.position.angle_to_point(player.body.position) + PI
		var direction = Vector2(cos(angle), sin(angle))
		if distance > 0:
			velocity = max_speed * direction
		else:
			velocity = Vector2()
		if face:
			face.rotation = -body.rotation
	if attack:
		if attack.is_done():
			move_face(mid)
			yield(get_tree().create_timer(0.5 / stats.speed), "timeout")
			move_face(get_face_pos())
			attack = pick_attack()
	if player && body:
		var diff = player.body.position - body.position
		if abs(diff.length()) > 3000:
			if enrage_timer.is_stopped():
				enrage_timer.wait_time = 0.5 / stats.fire_rate
				enrage_timer.start()
				var tele_max_dist = 300
				var off = Vector2(rand_range(-tele_max_dist, tele_max_dist), rand_range(-tele_max_dist, tele_max_dist))
				teleport_marker.position = player.body.position + off
				Quick.tween_show(teleport_marker)
		else:
			if !enrage_timer.is_stopped():
				enrage_timer.stop()
				Quick.tween_hide(teleport_marker)

func enraged() -> void:
	if player:
		boss_body.teleport(teleport_marker.position)
		player.shockwave.boom(teleport_marker.position, 2, 1)
