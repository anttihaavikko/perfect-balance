extends Reference
class_name Stats

var hp := 3
var hp_max := 2
var speed := 0.5
var shot_range := 1.0
var damage := 1
var fire_rate := 0.5
var shot_speed := 0.5
var homing := 0.0
var luck := 0.1
var picks := 1
var drone := 0

func _init(stats = null) -> void:
	if stats:
		hp = stats.hp
		hp_max = stats.hp_max
		speed = stats.speed
		shot_range = stats.shot_range
		damage = stats.damage
		fire_rate = stats.fire_rate
		shot_speed = stats.shot_speed
		homing = stats.homing
		luck = stats.luck
		picks = stats.picks
		drone = stats.drone

func apply(bonus: Dictionary):
	print("Applying %s for %s" % [bonus.key, bonus.value as String])
	if get(bonus.key):
		if bonus.type == "add":
			self[bonus.key] += bonus.value
		if bonus.type == "multiply":
			self[bonus.key] *= bonus.value
			
	if hp_max <= 0:
		hp_max = 1
	
	if damage <= 0:
		damage = 1
