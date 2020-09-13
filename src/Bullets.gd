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
			var pos = b.position / 5 + 0.5 * res + cam.offset - cam.position / 5.0
			
			if b.is_enemy:
				draw_circle(pos, 10, color)
				
			draw_circle(pos, 7, Color.white)
	
func _process(delta):
	update()
