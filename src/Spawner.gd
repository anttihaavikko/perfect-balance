extends Node2D
class_name Spawner

onready var bat = preload("res://src/Bat.tscn")
onready var root = get_node("..")
onready var plr = get_node("../Player")
onready var shockwave = get_node("../Canvas/Shockwave")
onready var start_timer = $StartTimer
onready var timer = $Timer
onready var wave_timer = $WaveTimer
onready var appearer := $Appearer

export(PoolColorArray) var colors = PoolColorArray()

var noise_seed := 0
var angle := 0.0
var spawns := 0
var picked := false
var started := false

func _init() -> void:
	randomize()
	noise_seed = randi()
	angle = randf() * 2 * PI;

func spawn():
	if spawns == 0:
		pick_angle()
	if spawns < 7:
		var enemy = bat.instance()
		root.add_child(enemy)
		enemy.body.position = position
		shockwave.boom(position)
		enemy.seed_noise(noise_seed)
		enemy.body.rotation = angle
		enemy.colorize(colors[randi() % colors.size()])
		spawns += 1
	else:
		wave_timer.start()
		timer.stop()
		appearer.disappear()
			
func _on_StartTimer_timeout() -> void:
	if started:
		start_timer.stop()
		timer.start()
		started = false
	else:
		reposition()
		started = true
		
func _on_Timer_timeout() -> void:
	spawn()
	
func _on_WaveTimer_timeout() -> void:
	spawns = 0
	start_timer.start()
	
func pick_angle():
	if plr:
		angle = position.angle_to_point(plr.body.position) + PI
		picked = true
	
func reposition():
	var dir = randf() * 2 * PI;
	if plr:
		position = plr.body.get_global_transform().get_origin() + 1500 * Vector2(cos(dir), sin(dir)).normalized()
		appearer.appear()

func _on_Game_no_enemies() -> void:
	if timer.is_stopped() && start_timer.is_stopped():
		spawns = 0
		started = false
		start_timer.start()
		
