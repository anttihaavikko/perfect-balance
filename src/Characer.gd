extends Node2D
class_name Character

export var max_speed = 1000.0
export var is_enemy = true
export var hitbox_radius = 100
export var boss := false

onready var body: RigidBody2D = $Torso
onready var cam := get_node("../Camera")
onready var game: Game = get_node("..")
onready var shaker = get_node("../Camera/ScreenShake")
onready var shockwave = get_node("../Canvas/Shockwave")

var velocity := Vector2()
var angle := 0.0
var shot_cooldown := 0.0
var shot_cooldown_max := 0.3
var tween: Tween
var base_color: Color
var color_reset: Timer
var immortal := false

var stats: Stats;

var ignore_collision := 0

var picking_bonus := false

var scores := true
var is_dead := false

func _init() -> void:
	self.stats = Stats.new()
	calculate_hp()
	
func calculate_hp():
	stats.hp = stats.hp_max * 10 if boss else stats.hp_max

func _ready() -> void:
	tween = Tween.new()
	add_child(tween)
	base_color = modulate
	yield(get_tree().create_timer(0.1), "timeout")
	game.add_character(self)
	
func _move(delta):
	var mod = 0.2 if boss else 1.0
	body.linear_velocity = velocity * 300 * delta * stats.speed * mod
	body.angular_velocity = angle * 30000 * delta * stats.speed * mod
	
func _process(delta):
	if immortal && randi() % 3 == 0:
		modulate = Stuff.colors[randi() % 5]
		
	if ignore_collision > 0:
		ignore_collision -= delta
	
	if shot_cooldown > 0:
		shot_cooldown -= delta * stats.fire_rate
		
func recoil():
	shaker.start(0.1, 20, 3)
	
func _update_hp():
	pass
	
func _took_damage():
	pass
	
func damage(amount: int):
	if is_dead:
		return
		
	if !picking_bonus && !immortal:
		stats.hp -= amount
		_update_hp()
		_took_damage()
		
	var vol = 1.0 if !is_enemy else 0.5
	 
	AudioManager.add(8, body.position, 1.000000 * vol)
	AudioManager.add(9, body.position, 1.000000 * vol)
	AudioManager.add(10, body.position, 1.000000 * vol)
	AudioManager.add(29, body.position, 1.250000)
	
	if !immortal:	
		flash()
	
func take_hit(bullet: Bullet):
	damage(bullet.damage)
	
func is_alive() -> bool:
	return stats.hp > 0
	
func die():
	if scores:
		var amt = 100 if !boss else game.spawner.level * 1000
		game.score.add(amt)
		game.score.add_multi()
		
	
	AudioManager.add(2, body.position, 1.300000)
	AudioManager.add(3, body.position, 1.100000)
	AudioManager.add(4, body.position, 1.500000)
	AudioManager.add(5, body.position, 1.000000)
	AudioManager.add(29, body.position, 1.500000)
		
	stats.hp = 0
	_update_hp()
	boom(body.position)
	AudioManager.add(1, body.position)
	shaker.start(0.4, 20, 15)
	game.spawn_pickup_on(body.position)
	_died()
	
	if is_enemy:
		queue_free()
	else:
		is_dead = true
		hide()
	
func _died():
	pass
	
func boom(pos: Vector2, amount: float = 1.0, duration: float = 1.2):
	shockwave.boom(pos, amount, duration)
	game.pulse(pos)

func flash(color: int = 0):
	shaker.start(0.15, 20, 3 if is_enemy else 10)
	modulate = game.colors[color]
	yield(get_tree().create_timer(0.1), "timeout")
	modulate = base_color
	
func collided(other):
	var c = other.get_node("..")
	if ignore_collision <= 0 && c.is_enemy:
		ignore_collision = 0.5
		damage(game.spawner.stats.damage)
		if immortal:
			c.damage(999)

func _on_Head_body_entered(body: Node) -> void:
	collided(body)
	
func _on_Pelvis_body_entered(body: Node) -> void:
	collided(body)

func _on_Limb_Upper_body_entered(body: Node) -> void:
	collided(body)

func _on_Limb_Lower_body_entered(body: Node) -> void:
	collided(body)

func _on_Limb_Upper2_body_entered(body: Node) -> void:
	collided(body)

func _on_Limb_Lower2_body_entered(body: Node) -> void:
	collided(body)

func _on_Limb_Upper3_body_entered(body: Node) -> void:
	collided(body)

func _on_Limb_Lower3_body_entered(body: Node) -> void:
	collided(body)

func _on_Limb_Upper4_body_entered(body: Node) -> void:
	collided(body)

func _on_Limb_Lower4_body_entered(body: Node) -> void:
	collided(body)
