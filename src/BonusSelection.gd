extends HBoxContainer

onready var tile = preload("res://src/BonusTile.tscn")
onready var player = get_node("../../../Player");

var bonuses = []

func show_bonuses():
	yield(get_tree().create_timer(1.5), "timeout")
	
	if player:
		player.picking_bonus = true
		yield(get_tree().create_timer(1.5), "timeout")
	
		for index in range(5):
			var bonus = tile.instance()
			bonus.modulate.a = 0;
			add_child(bonus)
			bonus.setup(get_bonus())
			bonuses.append(bonus)
			bonus.slide(index * 0.15)

func hide_bonuses():
	var delay = 0.0
	for bonus in bonuses:
		bonus.slide_and_free(delay)
		delay += 0.15
		
	bonuses.clear()
	
func get_bonus():
	var bonuses = [
		{
			"title": "MAX HP",
			"desc": "{value}",
			"key": "hp_max",
			"type": "add",
			"value": 1 + randi() % 4
		},
		{
			"title": "DAMAGE",
			"desc": "{value}",
			"key": "damage",
			"type": "add",
			"value": 1
		},
		{
			"title": "SPEED",
			"desc": "{value}",
			"key": "speed",
			"type": "multiply",
			"value": rand_range(1.05, 1.5)
		},
		{
			"title": "RANGE",
			"desc": "{value}",
			"key": "shot_range",
			"type": "multiply",
			"value": rand_range(1.05, 1.5)
		},
		{
			"title": "FIRE RATE",
			"desc": "{value}",
			"key": "fire_rate",
			"type": "multiply",
			"value": rand_range(1.05, 1.5)
		},
		{
			"title": "SHOT SPEED",
			"desc": "{value}",
			"key": "shot_speed",
			"type": "multiply",
			"value": rand_range(1.05, 1.5)
		},
		{
			"title": "FULL HEAL",
			"desc": "Patched up!",
			"key": "heal",
			"type": "custom",
			"value": 0
		}
	]
	
	return bonuses[randi() % bonuses.size()]
