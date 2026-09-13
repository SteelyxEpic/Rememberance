extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(entered)
	mouse_exited.connect(exited)

func entered():
	Global.emit_signal("rotate", true)
	$"..".within = true

func exited():
	Global.emit_signal("rotate", false)
	$"..".within = false
