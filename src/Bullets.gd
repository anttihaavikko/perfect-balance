extends CanvasItem
class_name Bullets

export (NodePath) var camera
export (NodePath) var gamePath

export var color: Color;

onready var cam := get_node("../../Camera")
onready var game: Game = get_node("../..")

func _draw():
	if game:
		for b in game.bullets:
			
			var res = Vector2(1024, 600)
			var pos = adjust_point(b.position)
			var prev = adjust_point(b.prev_pos)
			
			if b.is_enemy:
				draw_line(prev, pos, dim(b.color), 12, true)
				draw_circle(pos, 10, b.color)
				
			if !b.is_enemy:
				draw_line(prev, pos, dim(Color.white), 9, true)
				
			draw_circle(pos, 7, Color.white)
			
func adjust_point(pos: Vector2) -> Vector2:
	var res = Vector2(1024, 600)
	return pos / 5 + 0.5 * res + cam.offset - cam.position / 5.0
	
func dim(color: Color) -> Color:
	return Color(color.r, color.g, color.b, 0.2)
	
func _process(delta):
	update()
