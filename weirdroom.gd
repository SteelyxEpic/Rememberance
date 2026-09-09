extends Sprite2D

@onready var godcon:Node2D = $Godcon
@onready var god:Sprite2D = $Godcon/God
var positions: Array[Vector2] = [Vector2(17, -55), Vector2(55, 16), Vector2(43, 107)]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movearound()
	hover()


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
	
