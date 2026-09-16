extends Sprite2D

var holdingdown:bool
var temp:float
var previous:float
var within:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (within or holdingdown):
			if not holdingdown:
				holdingdown = true
				Global.emit_signal("rotate", false)
				temp = global_position.angle_to_point(get_global_mouse_position()) - rotation
			var location = global_position.angle_to_point(get_global_mouse_position())
			rotation = location - temp
			
		elif holdingdown:
			holdingdown = false
