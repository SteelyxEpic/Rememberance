extends Node2D

@export var distance = 2
var index = 0
var current
# Called when the node enters the scene tree for the first time
func _ready() -> void:
	Global.clicked.connect(func():
		if not visible: 
			click())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(Global.object) > 0 and not visible:
		global_position = get_global_mouse_position()
		$"../interactables".show()
		$"../interactables".global_position = get_global_mouse_position()
	else:
		$"../interactables".hide()
	var diff = global_position.distance_to(get_global_mouse_position())
	var angle = global_position.angle_to_point(get_global_mouse_position())
	for i in get_children():
		i.scale = Vector2(1, 1)
	if diff < distance:
		index = ceil(angle/PI*2)
		get_child(index).scale = Vector2(1.1, 1.1)
		

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and visible:
			if index == 1:
				back()
			elif index == -1:
				Global.emit_signal("speech", current.speech)
			elif index == 0:
				current.click()
				back()

func click():
	current = Global.object[-1]
	show()
	scale = Vector2(0, 0)
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.4, 0.4), 0.2)
	await tween.finished
func back():
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.2)
	await tween.finished
	hide()
