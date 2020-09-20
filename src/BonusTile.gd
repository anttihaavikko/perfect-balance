extends ColorRect

onready var game = get_node("../../../..");
onready var tween: Tween = $Tween
onready var title: Label = $ColorRect/Title
onready var desc: Label = $ColorRect/Desc
onready var icon: TextureRect = $ColorRect/Icon
onready var stamp_pos = $StampSpot
onready var stamp_player = preload("res://src/StampPlayer.tscn")
onready var stamp_enemy = preload("res://src/StampEnemy.tscn")

var picked := false
var bonus: Dictionary
var index: int;
var cam;

func _ready() -> void:
	cam = game.get_node("Camera")

func _on_Button_mouse_entered() -> void:
	if !picked:
		color = game.colors[0]
		tween.interpolate_property(self, "margin_top", 0, -50, 0.15, Tween.TRANS_BOUNCE)
		tween.start()
		AudioManager.add(18, cam.position + rect_position, 0.500000)
		AudioManager.add(15, cam.position + rect_position, 0.500000)

func _on_Button_mouse_exited() -> void:
	if !picked:
		color = Color.white
		tween.interpolate_property(self, "margin_top", -50, 0, 0.15, Tween.TRANS_BOUNCE)
		tween.start()
		AudioManager.add(18, cam.position + rect_position, 0.500000)
		AudioManager.add(15, cam.position + rect_position, 0.500000)

func _on_Button_pressed() -> void:
	if !picked:
		game.pick_bonus(bonus, index)
		picked = true
		color = game.colors[3]
		AudioManager.add(0, cam.position + rect_position, 1.000000)
		AudioManager.add(1, cam.position + rect_position, 0.500000)
		yield(get_tree().create_timer(0.3), "timeout")
		add_stamp()
	
func slide(delay: float):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.interpolate_property(self, "margin_top", 300, 0, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	
func slide_and_free(delay: float):
	yield(get_tree().create_timer(delay), "timeout")
	tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.interpolate_property(self, "margin_top", 0, 400, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(5), "timeout")
	queue_free()
	
func setup(bonus: Dictionary, index: int):
	self.index = index
	self.bonus = bonus
	title.text = bonus.title
	
	if !bonus.cursed:
		$ColorRect/Cursed.hide()
		$CurseParticles.hide()
	
	icon.texture = load("res://assets/sprites/bonuses/%s.png" % bonus.texture)
	
	if bonus.type == "add":
		desc.text = bonus.desc.replace("{value}", get_prefix(bonus) + bonus.value as String)
		
	if bonus.type == "multiply":
		desc.text = bonus.desc.replace("{value}", get_prefix(bonus) + round((bonus.value - 1) * 100) as String + " %")
		
	if bonus.type == "custom":
		desc.text = bonus.desc.replace("{value}", bonus.value)
	
func get_prefix(bonus: Dictionary) -> String:
	return "+" if bonus.value >= 0 else "-"
	
func add_stamp(good: bool = true):
#	yield(get_tree().create_timer(0.1), "timeout")
	var stamp = stamp_player.instance() if good else stamp_enemy.instance()
	add_child(stamp)
	var angle = randf() * 2 * PI
	stamp.position = rect_size * 0.5 + Vector2(cos(angle), sin(angle)) * 50
	tween.interpolate_property(stamp, "scale", Vector2.ZERO, Vector2.ONE, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.interpolate_property(stamp, "rotation", 0, rand_range(-0.5, 0.5), 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	var vol = 1 if good else 0.6
	AudioManager.add(9, cam.position + rect_position, 1.000000 * vol)
	AudioManager.add(10, cam.position + rect_position, 1.000000 * vol)
	AudioManager.add(12, cam.position + rect_position, 1.000000 * vol)
	AudioManager.add(13, cam.position + rect_position, 0.600000 * vol)
