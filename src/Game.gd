extends Node2D
class_name Game

signal no_enemies

export(PoolColorArray) var colors = PoolColorArray()

var bullets := []
var characters := []

onready var bits = preload("res://src/Bits.tscn")
onready var parts = preload("res://src/Parts.tscn")
onready var player = $Player
onready var bonuses = get_node("Canvas/BonusView/BonusSelection")
onready var spawner = $Spawner

var emitted := false

func get_random_color() -> Color:
	return colors[randi() % colors.size()]

func add_bullet(bullet: Bullet):
	bullets.append(bullet)

func _process(delta):
	var used = []
	var dead = []
	
	var alive = 0;
	for c in characters:
		if c.is_enemy:
			alive += 1
	
	if alive == 0 && !emitted:
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
			
	if dead.size() > 0:
		for i in dead:
			characters[i].die()
			characters.remove(i)
			
	if Input.get_action_strength("restart"):
		get_tree().reload_current_scene()

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
	bonuses.show_bonuses()
	
func pick_bonus(bonus: Dictionary):
	player.stats.apply(bonus)
	player._update_hp()
	bonuses.hide_bonuses()
	player.picking_bonus = false
	spawner.next_level()
