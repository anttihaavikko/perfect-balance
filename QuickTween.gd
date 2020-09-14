class_name QuickTween

static func from_to(container: CanvasItem, object, field: String, cur, value, time: float):
	var tween = Tween.new()
	container.add_child(tween)
	tween.interpolate_property(object, field, cur, value, time, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
