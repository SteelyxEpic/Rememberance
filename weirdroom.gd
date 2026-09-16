extends Sprite2D

@onready var godcon:Node2D = $front/Godcon
@onready var god:Sprite2D = $front/Godcon/God
var positions: Array[Vector2] = [Vector2(17, -55), Vector2(55, 16), Vector2(43, 107)]
@onready var front:Texture2D = load("res://weirdroom.png")
@onready var back:Texture2D = load("res://bedroom.png")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.change.connect(change)
	movearound()
	hover()
	
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
func movearound():
	while true:
		var move_tween = get_tree().create_tween()
		var xoffset = 70 * (-1 if randi_range(0, 1) == 0 else 1)
		var temp: Vector2 = positions.pick_random()
		temp.x += xoffset
		move_tween.tween_property(godcon, "position", temp, 3)
		await get_tree().create_timer(3.5).timeout

func hover():
	while true:
		var hover_tween = get_tree().create_tween()
		hover_tween.tween_property(god, "position:y", 15, 3)
		await get_tree().create_timer(3).timeout
		hover_tween.stop()
		hover_tween = get_tree().create_tween()
		hover_tween.tween_property(god, "position:y", -15, 3)
		await get_tree().create_timer(3).timeout
	
