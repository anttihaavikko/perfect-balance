extends Node2D

onready var go = $MainCanvas/Go
onready var input = $MainCanvas/LineEdit

func _ready() -> void:
	TransitionScreen.open()
	OS.low_processor_usage_mode = true
	go.hide()
	input.grab_focus()
	AudioManager.lowpass()

func _on_LineEdit_text_entered(new_text: String) -> void:
	if new_text.length() > 0:
		start_game()

func _on_LineEdit_text_changed(new_text: String) -> void:
	
	AudioManager.add(27, Vector2(512, 300), 1.300000)
	AudioManager.add(9, Vector2(512, 300), 0.600000)

	if new_text.length() > 0:
		go.show()
	else:
		go.hide()

func _on_Go_clicked() -> void:
	start_game()

func start_game():
	AudioManager.lowpass(false)
	ScoreManager.player_name = input.text;
	TransitionScreen.close()
	yield(get_tree().create_timer(TransitionScreen.transition_time), "timeout")
	get_tree().change_scene("res://src/Game.tscn")
