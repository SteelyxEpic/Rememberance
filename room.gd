extends Sprite2D

var positions: Array[Vector2] = [Vector2(17, -55), Vector2(55, 16), Vector2(43, 107)]
@export var front:Texture2D = load("res://weirdroom.png")
@export var back:Texture2D = load("res://bedroom.png")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.change.connect(change)
	find_child("front").visibility_changed.connect(func():
		if texture == front:
			texture = back
		else:
			texture = front)

func change(current, direction):
	if name == current:
		Global.current = self
		show()
		if direction:
			find_child("front").hide()
			find_child("back").show()
			texture = back
		else:
			find_child("front").show()
			find_child("back").hide()
			texture = front
	else:
		hide()
