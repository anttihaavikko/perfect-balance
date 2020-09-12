extends Node2D
class_name Character

export var max_speed = 1000.0
export var is_enemy = true
export var hitbox_radius = 100

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
var hp_max = 5
var hp

func _ready() -> void:
	hp = hp_max
	tween = Tween.new()
	add_child(tween)
	base_color = modulate
	yield(get_tree().create_timer(0.1), "timeout")
	game.add_character(self)
	
func _move(delta):
	body.linear_velocity = velocity * 300 * delta
	body.angular_velocity = angle * 30000 * delta
	
func _process(delta):
	if(shot_cooldown > 0):
		shot_cooldown -= delta
		
func recoil():
	shaker.start(0.1, 20, 3)
	
func take_hit(bullet: Bullet):
	hp -= bullet.damage
	flash()
	
func is_alive() -> bool:
	return hp > 0
	
func die():
	get_node("../Canvas/Shockwave").boom(body.position)
	shaker.start(0.4, 20, 15)
	queue_free()

func flash():
	shaker.start(0.15, 20, 3 if is_enemy else 10)
	modulate = Color.white
	yield(get_tree().create_timer(0.2), "timeout")
	modulate = base_color
	#tween.interpolate_property(self, "modulate", Color.white, base_color, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	#tween.start()
