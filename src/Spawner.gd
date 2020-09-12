extends Node2D
class_name Spawner

onready var bat = preload("res://src/Bat.tscn")
onready var root = get_node("..")
onready var plr = get_node("../Player")

var noise_seed := 0
var angle := 0.0
var spawns := 0
var picked := false

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
		enemy.seed_noise(noise_seed)
		enemy.body.rotation = angle
		spawns += 1
		
func _on_Timer_timeout() -> void:
	spawn()
	
func pick_angle():
	print(position, " vs ", plr.body.position)
	angle = position.angle_to_point(plr.body.position) + PI
	print("picked angle ", angle)
	picked = true
