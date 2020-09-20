extends Node2D

onready var form = $Form/Label
onready var effects = $Effects
onready var input = $Form/Index

var preview := 0
var clips = []
var volumes = []

func _ready() -> void:
	TransitionScreen.open()
	input.text = preview as String
	form.text = AudioManager.effects[preview]

func _on_Button_pressed() -> void:
	print("------------------------")
	for i in range(clips.size()):
		AudioManager.add(clips[i], Vector2(512, 300), volumes[i])
		print("AudioManager.add(%d, position, %f)" % [clips[i], volumes[i]])

func _on_Index_text_changed(new_text: String) -> void:
	preview = int(new_text)
	if preview >= 0 && preview < AudioManager.effects.size():
		form.text = AudioManager.effects[preview]

func _on_Play_pressed() -> void:
	AudioManager.add(preview)

func _on_Add_pressed() -> void:
	var container = VBoxContainer.new()
	effects.add_child(container)
	var label = Label.new()
	label.text = AudioManager.effects[preview]
	container.add_child(label)
	var input = LineEdit.new()
	input.text = "1.0"
	input.connect("text_changed", self, "volume_changed", [clips.size()])
	container.add_child(input)
	clips.append(preview)
	volumes.append(1.0)

func volume_changed(txt: String, index: int):
	print("volume to %s" % txt)
	volumes[index] = float(txt)

func _on_Next_pressed() -> void:
	preview = (preview + 1) % AudioManager.effects.size()
	input.text = preview as String
	form.text = AudioManager.effects[preview]

func _on_Prev_pressed() -> void:
	preview -= 1
	if preview < 0:
		preview = AudioManager.effects.size() - 1
	input.text = preview as String
	form.text = AudioManager.effects[preview]
