extends Sprite2D

func _ready() -> void:
	Global.statics.connect(func():
		material.set_shader_parameter("static_intensity", 1)
		$AudioStreamPlayer2D.play()
		await $AudioStreamPlayer2D.finished
		var tween:Tween = create_tween()
		tween.tween_method(
			func(val): material.set_shader_parameter("static_intensity", val),
			1.0, 
			0.2, 
			0.5
		))
	Global.staticchange.connect(func(x):
		material.set_shader_parameter("static_intensity", x)
	)
