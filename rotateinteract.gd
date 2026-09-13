extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "rotation_degrees", 360, 2)
	tween.tween_property(self, "rotation_degrees", 0, 0)
	Global.rotate.connect(func(x):
		if x:
			show()
		else:
			hide())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
