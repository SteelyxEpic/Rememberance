extends TextureButton 

@export var key: bool

func _ready() -> void:
	pressed.connect(pressing)
	mouse_entered.connect(func():
		Global.interact.keyon = true
		)
	mouse_exited.connect(func():
		Global.interact.keyon = false
		)

func pressing():
	if key:
		Global.keys += 1
	else:
		Global.inventory.append(name)
	hide()
