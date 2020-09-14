extends Node2D

onready var data = preload("res://nativebullets/nativebullets.gdns").new()

func _on_Button_pressed() -> void:
	$Label.text = "Data = " + data.get_data()
