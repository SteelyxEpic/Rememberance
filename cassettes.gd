extends TextureButton

var tween:Tween
var y:float
@export var speech:Array[Dialogue]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(func():
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "position:y", y - 30, abs(position.y - (y + 30))/90)
		)
	mouse_exited.connect(func():
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "position:y", y, abs(position.y - y)/90)
		)
	pressed.connect(func():
		Global.boombox.hide()
		Global.emit_signal("speech", speech))
