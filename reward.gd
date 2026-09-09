extends TextureButton 

func _ready() -> void:
	pressed.connect(pressing)

func pressing():
	Global.inventory.append(name)
	hide()
