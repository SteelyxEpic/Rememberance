extends Area2D # Changed from Sprite2D

@export var speech:Dictionary[String, AudioStreamMP3]

func _ready() -> void:
	input_event.connect(_on_input_event)
	mouse_entered.connect(func():
		Global.mouse(self, false))
	mouse_exited.connect(func():
		Global.mouse(self, true))
		
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Global.emit_signal("clicked")
			
