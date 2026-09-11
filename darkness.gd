extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dark()


func dark():
	while true:
		var hover_tween = get_tree().create_tween()
		var random = randf_range(0.5, 3.5)
		hover_tween.tween_property(self, "modulate:a", 1, random)
		await get_tree().create_timer(random).timeout
		hover_tween.stop()
		hover_tween = get_tree().create_tween()
		random = randf_range(0.5, 3.5)
		hover_tween.tween_property(self, "modulate:a", 230.0/255.0, random)
		await get_tree().create_timer(random).timeout
