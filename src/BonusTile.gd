extends ColorRect

onready var game = get_node("../../../..");
onready var tween: Tween = $Tween
onready var title: Label = $ColorRect/Title
onready var desc: Label = $ColorRect/Desc

var picked := false
var bonus: Dictionary

func _on_Button_mouse_entered() -> void:
	color = game.colors[0]
	tween.interpolate_property(self, "margin_top", 0, -50, 0.15, Tween.TRANS_BOUNCE)
	tween.start()

func _on_Button_mouse_exited() -> void:
	color = Color.white
	
	tween.interpolate_property(self, "margin_top", -50, 0, 0.15, Tween.TRANS_BOUNCE)
	tween.start()

func _on_Button_pressed() -> void:
	if !picked:
		game.pick_bonus(bonus)
	
func slide(delay: float):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.1, Tween.TRANS_BOUNCE)
	tween.interpolate_property(self, "margin_top", 300, 0, 0.3, Tween.TRANS_BOUNCE)
	tween.start()
	
func slide_and_free(delay: float):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.3, Tween.TRANS_BOUNCE)
	tween.interpolate_property(self, "margin_top", 0, 400, 0.3, Tween.TRANS_BOUNCE)
	tween.start()
	yield(get_tree().create_timer(5), "timeout")
	queue_free()
	
func setup(bonus: Dictionary):
	self.bonus = bonus
	title.text = bonus.title
	
	if bonus.type == "add":
		desc.text = get_prefix(bonus) + bonus.value as String
		
	if bonus.type == "multiply":
		desc.text = get_prefix(bonus) + round((bonus.value - 1) * 100) as String + " %"
		
	if bonus.type == "custom":
		desc.text = bonus.desc
	
func get_prefix(bonus: Dictionary) -> String:
	return "+" if bonus.value >= 0 else "-"
