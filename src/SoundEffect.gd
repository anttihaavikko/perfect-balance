extends Node2D
class_name SoundEffect

onready var audio := $Audio
onready var timer := $Timer

var index := -1

func _on_Timer_timeout() -> void:
	AudioManager.add_to_pool(self)
