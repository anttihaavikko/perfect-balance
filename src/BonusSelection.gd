extends HBoxContainer

onready var tile = preload("res://src/BonusTile.tscn")
onready var player = get_node("../../../Player");

var bonuses = []

func show_bonuses():
	yield(get_tree().create_timer(1.5), "timeout")
	player.picking_bonus = true
	yield(get_tree().create_timer(1.5), "timeout")
	for index in range(5):
		var bonus = tile.instance()
		bonus.modulate.a = 0;
		add_child(bonus)
		bonuses.append(bonus)
		bonus.slide(index * 0.15)

func hide_bonuses():
	for bonus in bonuses:
		bonus.hide()
		bonus.queue_free()
