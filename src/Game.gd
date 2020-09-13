extends Node2D
class_name Game

var bullets := []
var characters := []

onready var bits = preload("res://src/Bits.tscn")
onready var parts = preload("res://src/Parts.tscn")

func add_bullet(bullet: Bullet):
	bullets.append(bullet)

func _process(delta):
	var used = []
	var dead = []
	
	for i in range(bullets.size()):
		var bullet = bullets[i] as Bullet
		
		if !bullet.update(delta):
			used.push_front(i)
		else:
			for k in range(characters.size()):
				var c = characters[k]
				var diff = c.body.position - bullet.position;
				if c.is_enemy != bullet.is_enemy && abs(diff.length()) < c.hitbox_radius:
					bits(bullet.position)
					c.take_hit(bullet)
					if !c.is_alive():
						parts(c.body.position)
						dead.push_front(k)
					if used.find(i) == -1:
						used.push_front(i)
	
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

func bits(pos: Vector2):
	var eff = bits.instance()
	add_child(eff)
	eff.position = pos
	
func parts(pos: Vector2):
	var eff = parts.instance()
	add_child(eff)
	eff.position = pos
