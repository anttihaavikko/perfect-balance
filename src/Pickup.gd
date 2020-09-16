extends Area2D

onready var player = get_node("../Player")

var used := false

func _ready() -> void:
	rotation = randf() * 2 * PI

func _on_Pickup_body_entered(body: Node) -> void:
	if !used:
		player.game.score.add(25 if player.stats.hp < player.stats.hp_max else 500)
		used = true
		player.heal()
		player.boom(position, 0.5, 0.8)
		queue_free()
