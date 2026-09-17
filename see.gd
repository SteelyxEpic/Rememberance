extends Sprite2D

@onready var see = load("res://see.png")
@onready var seenot = load("res://seenothing.png")


func _ready() -> void:
	Global.change.connect(change)
	
func change(current, direction):
	await get_tree().process_frame
	if Global.light.visible:
		texture = see
	else:
		texture = seenot
