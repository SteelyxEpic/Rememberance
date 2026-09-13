extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.keychange.connect(update)

func update():
	text = "x " + str(Global.keys)
