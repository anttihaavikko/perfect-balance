extends CanvasItem

var tweener: Tween
var size: float = 0
var amount: float = 0.1
var thickness: float = 0.04

func _ready():
	tweener = Tween.new()
	add_child(tweener)
		
func boom(pos: Vector2):
	var screen := OS.get_window_size()
	var view = get_viewport().size
	var offset = (2.5 * view + pos) / 5.0
	var uv := Vector2(offset.x / view.x, 1 - offset.y / view.y)
	material.set_shader_param("origin", uv)
	tweener.interpolate_property(self, "size", 0, 0.3, 1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tweener.interpolate_property(self, "thickness", 0.2, 0, 1.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tweener.interpolate_property(self, "amount", 0.1, 0, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tweener.start()

func _process(delta):
	material.set_shader_param("size", size)
	material.set_shader_param("amount", amount)
	material.set_shader_param("thickness", thickness)
