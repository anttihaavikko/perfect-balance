extends Attack
class_name Spread

var bursts
var step = 0.0

func _init(bursts, step = 0.0) -> void:
	self.bursts = bursts
	self.step = step
	
	for b in bursts:
		b._init(b.type, b.curve, b.shots, b.lifetime, b.spin, b.straighten)
		b.prepare_next()
		
func _update(game: Node2D, enemy, delta: float):
	for b in bursts:
		b._update(game, enemy, delta)
		
func is_done() -> bool:
	var all = true
	
	for b in bursts:
		if !b.is_done():
			all = false
			
	return all

func _shoot(game: Node2D, enemy, angle: float, delta: float):
	var offset = (bursts.size() - 1) * 0.5 * step
	var i = 0
	for b in bursts:
		b._shoot(game, enemy, angle - offset + i * step, delta)
		i += 1
