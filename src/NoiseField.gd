extends TextureRect

var img: Image
var tex: Texture
var noise: OpenSimplexNoise

onready var timer: Timer = $Timer

var points: PoolVector2Array = []

var offset_angle := 0
var index := 1
var frame_count := 180

func _ready() -> void:
	tex = load("res://assets/sprites/icon.png")
	img = tex.get_data()
	img.resize(1024, 600)
	img.fill(Color.black)

	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 250
	noise.persistence = 1.0

	reset_points()

func reset_points():
	rand_seed(123123123321)

	points = []

	for i in range(30000):
		points.append(Vector2(randi() % 1024, randi() % 600))

func _process(delta: float) -> void:
	for i in range(1):
		draw_step()
#	next_frame()

func draw_step():
	img.lock()
	for i in range(1):
		redraw()
	img.unlock()
	var it = ImageTexture.new()
	it.create_from_image(img)
	texture = it

func redraw():
	for p in points:
		var cur = img.get_pixel(p.x, p.y)
		var alpha = 0.05
		img.set_pixel(p.x, p.y, Color(cur.r + alpha, cur.g + alpha, cur.b + alpha, 1))
	move_points()

func move_points():
	for i in range(points.size()):
		var p = points[i]
		var radius = 10.0
		var noise_val = noise.get_noise_4d(p.x, p.y, cos(offset_angle) * radius, sin(offset_angle) * radius) * 3
#		var noise_val = noise.get_noise_2d(p.x, p.y) * 3
		var angle = noise_val * PI
#		print(noise_val, " => ", angle)
		var diff = 0.0
		points[i] += Vector2(round(cos(angle) + rand_range(-diff, diff)), round(sin(angle) + rand_range(-diff, diff)))
		if points[i].x < 0:
			points[i].x = img.get_width() - 1
		if points[i].x > img.get_width() - 1:
			points[i].x = 0
		if points[i].y < 0:
			points[i].y = img.get_height() - 1
		if points[i].y > img.get_height() - 1:
			points[i].y = 0
			
func next_frame():
	offset_angle += 2 * PI / frame_count
	img.save_png("../noises/%010d.png" % index)
	img.fill(Color.black)
	index += 1
	reset_points()
	print("frame %d" % index)
#
	if index > frame_count:
		timer.stop()


func _on_Timer_timeout() -> void:
	next_frame()
