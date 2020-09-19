extends Node2D

onready var go = $MainCanvas/Go
onready var input = $MainCanvas/LineEdit

func _ready() -> void:
	OS.low_processor_usage_mode = true
	go.hide()
	input.grab_focus()

func _on_LineEdit_text_entered(new_text: String) -> void:
	if new_text.length() > 0:
		start_game()

func _on_LineEdit_text_changed(new_text: String) -> void:
	if new_text.length() > 0:
		go.show()
	else:
		go.hide()

func _on_Go_clicked() -> void:
	start_game()

func start_game():
	ScoreManager.player_name = input.text;
	get_tree().change_scene("res://src/Game.tscn")
