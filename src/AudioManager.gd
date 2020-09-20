extends Node2D

export var effects: PoolStringArray = []

var effect = preload("res://src/SoundEffect.tscn")
var pools = []

func _ready() -> void:
	for i in range(effects.size()):
		pools.append([])
#		print("init pool for %d (%s)" % [i, effects[i]])

func add(index: int, pos: Vector2 = Vector2(512, 300), volume: float = 1.0):
#	print("playing effect %d" % index)
	var e = create(index)
	e.index = index
	e.position = pos
	e.audio.pitch_scale = rand_range(0.9, 1.1)
	e.audio.volume_db = log(volume)  * 20
	e.audio.play()
	e.timer.wait_time = e.audio.stream.get_length()
	e.timer.start()
	
func create(index: int):
	if pools[index].size() > 0:
		return pools[index].pop_front()
	else:
		var path = "res://assets/sounds/%s.wav" % effects[index]
		var e = effect.instance()
		add_child(e)
		e.audio.stream = load(path)
		return e

func add_to_pool(e):
	pools[e.index].append(e)
#	print("adding to pool %d (%d)" % [e.index, pools[e.index].size()])
