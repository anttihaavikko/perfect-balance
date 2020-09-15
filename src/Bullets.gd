extends CanvasItem
class_name Bullets

export (NodePath) var camera
export (NodePath) var gamePath

export var color: Color;

onready var cam := get_node("../../Camera")
onready var game: Game = get_node("../..")

onready var nb = get_node("../NativeBullets")

var previous_count = 0

func _draw():
	if game:
		
		var no_lines = previous_count > 150;
		var no_fills = previous_count > 300;
		
#		print(previous_count)
		
		previous_count = 0
		
		for b in game.bullets:
			
			var res = Vector2(1024, 600)
			var pos = adjust_point(b.position)
			var prev = adjust_point(b.prev_pos)
			
			if pos.x < 0 || pos.y < 0 || pos.x > res.x || pos.y > res.x:
				continue
				
			previous_count += 1
			
			if b.is_enemy:
				if !no_lines:
					draw_line(prev, pos, dim(b.color), 12, true)
					
				if !no_fills:
					draw_circle(pos, 10, b.color)
				
			if !no_lines && !b.is_enemy:
				draw_line(prev, pos, dim(Color.white), 9, true)
				
			var color = b.color if no_fills else Color.white
			draw_circle(pos, 7, color)
			
func adjust_point(pos: Vector2) -> Vector2:
	var res = Vector2(1024, 600)
	return pos / 5 + 0.5 * res + cam.offset - cam.position / 5.0
	
func dim(color: Color) -> Color:
	return Color(color.r, color.g, color.b, 0.2)
	
func _process(delta):
	update()
	pass
