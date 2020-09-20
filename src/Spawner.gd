extends Node2D
class_name Spawner

onready var bat = preload("res://src/Bat.tscn")
onready var slime = preload("res://src/SlimeBoss.tscn")
onready var root = get_node("..")
onready var plr = get_node("../Player")
onready var shockwave = get_node("../Canvas/Shockwave")
onready var start_timer = $StartTimer
onready var timer = $Timer
onready var wave_timer = $WaveTimer
onready var appearer := $Appearer
onready var game = get_node("..")
onready var wave_info: Label = get_node("../Canvas/LevelInfo")

var noise_seed := 0
var angle := 0.0
var spawns := 0
var picked := false
var started := false
var wave := 1
var level := 1
var boss_encountered := false
var wave_angle := 0

var stats: Stats

const spawn_boss_on_wave = 6
const waves = [4, 4, 5, 5, 6]

func _init() -> void:
	stats = Stats.new()
	randomize()
	noise_seed = randi()
	angle = randf() * 2 * PI;
	
func wave_count() -> int:
	return waves[min(level - 1, waves.size() - 1)] - 1 + stats.picks
	
func is_boss_wave() -> bool:
	return wave == wave_count()

func spawn():
	if spawns == 0:
		pick_angle()
	if is_boss_wave():
		spawn_sound()
		AudioManager.add(30, position, 1.800000)
		var enemy = slime.instance()
		root.add_child(enemy)
		enemy.stats = Stats.new(stats)
		enemy.calculate_hp()
		enemy.body.position = position
		shockwave.boom(position)
		enemy.seed_noise(noise_seed)
		enemy.forks = min(level / 2 + 2 + stats.drone, 12)
		spawns += 1
		start_timer.stop()
		timer.stop()
		wave_timer.stop()
		appearer.disappear()
		wave += 1
		boss_encountered = true
	elif wave_has_more():
		spawn_sound()
		var enemy = bat.instance()
		root.add_child(enemy)
		enemy.stats = Stats.new(stats)
		enemy.calculate_hp()
		enemy.body.position = position
		shockwave.boom(position)
		enemy.seed_noise(noise_seed)
		enemy.forks = level
		enemy.angle_offset = angle
		spawns += 1
		if !wave_has_more():
			yield(get_tree().create_timer(0.75), "timeout")
			next_wave()
	else:
		next_wave()
		
func spawn_sound():
	AudioManager.add(3, position, 0.600000)
	AudioManager.add(10, position, 1.200000)
	AudioManager.add(11, position, 0.700000)
	AudioManager.add(13, position, 0.800000)

		
func wave_has_more() -> bool:
	return spawns < clamp(2 + wave, 3, 10)
		
func next_wave():
	wave += 1
	wave_timer.start()
	timer.stop()
	appearer.disappear()
			
func _on_StartTimer_timeout() -> void:
	if started:
		start_timer.stop()
		timer.wait_time = 0.5 / stats.speed
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
		noise_seed = randi()
		position = plr.body.get_global_transform().get_origin() + 1500 * Vector2(cos(dir), sin(dir)).normalized()
		scale = Vector2.ONE * 1.5 if is_boss_wave() else Vector2.ONE
		appearer.appear()
		wave_info.text = "Level " + level as String + "    ::    " + get_wave_name()
		AudioManager.add(25, position, 1.200000)
		AudioManager.add(21, position, 0.600000)
		AudioManager.add(20, position, 0.500000)
		AudioManager.add(19, position, 0.500000)
		
func get_wave_name() -> String:
	if is_boss_wave():
		return "Boss"
		
	return "Wave " + wave as String + " / " + (wave_count() - 1) as String

func _on_Game_no_enemies() -> void:
	if (timer.is_stopped() || !wave_has_more()) && start_timer.is_stopped():
		if !boss_encountered:
			spawns = 0
			started = false
			start_timer.start()
		else:
			game.show_bonuses()
			
func boss_killed():
	wave_info.text = "Level " + level as String + "    ::    End"
			
func next_level():
	level += 1
	wave = 1
	spawns = 0
	boss_encountered = false
	started = false
	stats.hp_max += 1
#	stats.damage += 1
	start_timer.start()
		
