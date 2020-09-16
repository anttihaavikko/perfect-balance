extends Node2D

onready var player = get_node("../Player")

var angle := 0
var speed := 1.5
var life := 0.0

var noise: OpenSimplexNoise

func _init() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 5
	noise.period = 30000.0
	noise.persistence = 0.5

func _ready() -> void:
	angle = randf() * 2 * PI

func follow(speed_mod: float, delta: float) -> void:
	if player:
		life += delta * 10000
		var a = angle + player.body.rotation
		var offset = Vector2(cos(a), sin(a)) * 230.0
		var diff = Vector2(noise.get_noise_1d(life), noise.get_noise_1d(-life))
		var target = player.body.position + offset
		var dir = target - position
		position += dir * speed * speed_mod * delta
		position += diff * 500.0 * delta
