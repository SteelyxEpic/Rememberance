extends TextureButton 

@export var key: bool

func _ready() -> void:
	pressed.connect(pressing)

func pressing():
	if key:
		Global.keys += 1
	else:
		Global.inventory.append(name)
	hide()
