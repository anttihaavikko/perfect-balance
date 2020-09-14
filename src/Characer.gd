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

var velocity := Vector2()
var angle := 0.0
var shot_cooldown := 0.0
var shot_cooldown_max := 0.3
var tween: Tween
var base_color: Color
var color_reset: Timer

var stats: Stats;

var picking_bonus := false

func _init() -> void:
	self.stats = Stats.new()
	calculate_hp()
	
func calculate_hp():
	stats.hp = stats.hp_max * 15 if boss else stats.hp_max

func _ready() -> void:
	tween = Tween.new()
	add_child(tween)
	base_color = modulate
	yield(get_tree().create_timer(0.1), "timeout")
	game.add_character(self)
	
func _move(delta):
	body.linear_velocity = velocity * 300 * delta * stats.speed
	body.angular_velocity = angle * 30000 * delta * stats.speed
	
func _process(delta):
	
	if(shot_cooldown > 0):
		shot_cooldown -= delta * stats.fire_rate
		
func recoil():
	shaker.start(0.1, 20, 3)
	
func _update_hp():
	pass
	
func take_hit(bullet: Bullet):
	if !picking_bonus:
		stats.hp -= bullet.damage
		_update_hp()
		
	flash()
	
func is_alive() -> bool:
	return stats.hp > 0
	
func die():
	stats.hp = 0
	_update_hp()
	get_node("../Canvas/Shockwave").boom(body.position)
	shaker.start(0.4, 20, 15)
	queue_free()

func flash():
	shaker.start(0.15, 20, 3 if is_enemy else 10)
	modulate = game.colors[0]
	yield(get_tree().create_timer(0.1), "timeout")
	modulate = base_color
	#tween.interpolate_property(self, "modulate", Color.white, base_color, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	#tween.start()
