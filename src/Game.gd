extends Node2D
class_name Game

signal no_enemies

export(PoolColorArray) var colors = PoolColorArray()

var bullets := []
var bullet_positions := PoolVector2Array()
var bullet_colors := PoolColorArray()
var characters := []

onready var nb = get_node("BgCanvas/NativeBullets")
onready var cam = $Camera
onready var go = $Canvas/GameOver
onready var ab = $Canvas/AgainButton
onready var mb = $Canvas/MenuButton

onready var tutorial_move = $TutorialMove
onready var tutorial_aim = $TutorialAim
onready var tutorial_move_timer = $TutorialMoveTimer
onready var tutorial_aim_timer = $TutorialAimTimer

onready var bits = preload("res://src/Bits.tscn")
onready var parts = preload("res://src/Parts.tscn")
onready var pulse = preload("res://src/Pulse.tscn")
onready var pickup = preload("res://src/Pickup.tscn")
onready var player = $Player
onready var bonuses = get_node("Canvas/BonusView/BonusSelection")
onready var spawner = $Spawner
onready var score = $Canvas/Score

var emitted := false

var bonus_picks := 0
var allowed_picks = 1

var can_spawn := false

func _ready() -> void:
	TransitionScreen.open()
	OS.low_processor_usage_mode = true
	$Canvas/AgainButton.connect("clicked", self, "restart")
	
	$Canvas/GameOver.rect_scale = Vector2.ZERO
	$Canvas/AgainButton.rect_scale = Vector2.ZERO
	$Canvas/MenuButton.rect_scale = Vector2.ZERO

func get_random_color() -> Color:
	return colors[randi() % colors.size()]

func add_bullet(bullet: Bullet):
	bullets.append(bullet)
	bullet_positions.append(bullet.position)
	bullet_colors.append(bullet.color)
	var c = bullet.color
	c.a = 0 if bullet.is_enemy else 1
	bullet_colors.append(c)

func _process(delta):
	var used = []
	var dead = []
	
	var alive = 0;
	for c in characters:
		if c.is_enemy:
			alive += 1
	
	if alive == 0 && !emitted && can_spawn:
		emit_signal("no_enemies")
		emitted = true
	
	for i in range(bullets.size()):
		var bullet = bullets[i] as Bullet
		
		var too_far = false
		if player:
			var diff = player.body.position - bullet.position
			if abs(diff.length()) > 4000:
				too_far = true
		
		if !bullet.update(delta) || too_far:
			used.push_front(i)
		else:
			update_bullets(i, bullet)
			for k in range(characters.size()):
				var c = characters[k]
				var diff = c.body.position - bullet.position;
				if c.is_enemy != bullet.is_enemy && abs(diff.length()) < c.hitbox_radius:
					bits(bullet.position)
					c.take_hit(bullet)
					if used.find(i) == -1:
						used.push_front(i)
				if !c.is_alive() && dead.find(k) == -1:
						parts(c.body.position)
						dead.push_front(k)
	
	if used.size() > 0:
		for i in used:
			bullets.remove(i)
			bullet_positions.remove(i)
			bullet_colors.remove(i)
			
	if dead.size() > 0:
		for i in dead:
			if characters[i]:
				characters[i].die()
				characters.remove(i)
			
#	nb.update_bullets(bullet_positions, bullet_colors, cam.offset - cam.position / 5.0)
	
	# debug only stuffs
	if OS.is_debug_build():
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
			
		if Input.is_action_just_pressed("drone"):
			player.add_drone()
			
		if Input.is_action_just_pressed("fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen
			
		if Input.is_action_just_pressed("immortal"):
			player.immortal = true
			AudioManager.pitch_shift()

func add_character(character):
	characters.append(character)
	emitted = false

func bits(pos: Vector2):
	var eff = bits.instance()
	add_child(eff)
	eff.position = pos
	
func parts(pos: Vector2):
	var eff = parts.instance()
	add_child(eff)
	eff.position = pos
	
func show_bonuses():
	if player:
		allowed_picks = player.stats.picks
		spawner.boss_killed()
		bonuses.show_bonuses(bonus_picks, allowed_picks)
		
		yield(get_tree().create_timer(0.5), "timeout")
		AudioManager.add(31, player.body.position, 2)
		if player.immortal:
			player.stats.apply(bonuses.get_curse())
			player.immortal = false
			player.modulate = Color.white
			AudioManager.pitch_shift(false)
	
func enemy_pick(bonus: Dictionary):
	spawner.stats.apply(bonus)
	
	if bonus.key == "fire_rate":
		spawner.timer.wait_time /= bonus.value
		spawner.wave_timer.wait_time /= bonus.value
		
	if bonus.key == "heal":
		spawner.stats.hp_max *= 1.25
		
	if bonus.key == "points":
		score.add(-bonus.value * 0.5)
		
	if bonus.key == "multiplier":
		score.reset_multi()
		
	if bonus.cursed:
		spawner.stats.apply(bonuses.get_curse())
	
func pick_bonus(bonus: Dictionary, index: int):
	
	if bonus_picks < allowed_picks:
		player.stats.apply(bonus)
	
		if bonus.key == "heal":
			player.stats.hp = player.stats.hp_max
			
		if bonus.key == "drone":
			for i in range(bonus.value):
				player.add_drone()
			
		if bonus.key == "points":
			score.add(bonus.value)
			
		if bonus.key == "multiplier":
			score.multi_multi(bonus.value)
			
		if bonus.key == "fruit":
			player.immortal = true
			AudioManager.pitch_shift()
			Music.pitch_scale = 1.2
			
		if bonus.cursed:
			player.stats.apply(bonuses.get_curse())
			
		player._update_hp()
		
		bonuses.add_enemy_bonuses(index)
	
	bonus_picks += 1
	
	if bonus_picks >= allowed_picks:
		bonus_picks = 0
		yield(get_tree().create_timer(2.2), "timeout")
		bonuses.hide_bonuses()
		player.picking_bonus = false
		spawner.next_level()
	else:
		bonuses.update_title(bonus_picks, allowed_picks)
	
func spawn_pickup_on(pos: Vector2):
	if player:
		if randf() < 0.1 + player.stats.luck - spawner.stats.luck:
			var eff = pickup.instance()
			add_child(eff)
			eff.position = pos
	
func pulse(pos: Vector2):
	var eff = pulse.instance()
	add_child(eff)
	eff.position = pos
	
func update_bullets(i, bullet):
	bullet_positions[i] = bullet.position
	var a = 0 if bullet.is_enemy else 1
	bullet_colors[i] = Color(bullet.color.r, bullet.color.g, bullet.color.b, a)
	
func game_over():
	ScoreManager.submit(round(score.score), spawner.wave)
	yield(get_tree().create_timer(1.5), "timeout")
	appear_sound(go.rect_position)
	Quick.tween_show(go)
	yield(get_tree().create_timer(0.5), "timeout")
	appear_sound(ab.rect_position)
	Quick.tween_show(ab)
	yield(get_tree().create_timer(0.25), "timeout")
	appear_sound(mb.rect_position)
	Quick.tween_show(mb)
	
func appear_sound(pos):
	AudioManager.add(29, cam.position + pos, 1.000000)
	AudioManager.add(25, cam.position + pos, 1.000000)
	AudioManager.add(20, cam.position + pos, 1.000000)

func restart():
	TransitionScreen.close()
	yield(get_tree().create_timer(TransitionScreen.transition_time), "timeout")
	get_tree().reload_current_scene()	

func _on_Timer_timeout() -> void:
	if player:
		player.move_shown = true
		var angle = randf() * 2 * PI
		tutorial_move.position = player.body.position + Vector2(cos(angle), sin(angle)) * 800
		Quick.tween_show(tutorial_move)

func _on_TutorialAimTimer_timeout() -> void:
	if player:
		player.aim_shown = true
		var angle = randf() * 2 * PI
		tutorial_aim.position = player.body.position + Vector2(cos(angle), sin(angle)) * 800
		Quick.tween_show(tutorial_aim)
		yield(get_tree().create_timer(1.5), "script_changed")
		can_spawn = true
		spawner.start_timer.start()
