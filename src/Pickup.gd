extends Area2D

onready var player = get_node("../Player")

var used := false

func _ready() -> void:
	rotation = randf() * 2 * PI

func _on_Pickup_body_entered(body: Node) -> void:
	if !used:
		used = true
		player.heal()
		player.boom(position, 0.5, 0.8)
		queue_free()
