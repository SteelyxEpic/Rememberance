extends Node2D

@export var distance = 2
@onready var safe = $"../spinlock"
@onready var audio:AudioStreamMP3 = load("res://select.mp3")
@onready var audiowalk:AudioStreamMP3 = load("res://walk.mp3")
@onready var audioplayer:AudioStreamPlayer2D = $"../sfx"
var index = 0
var prev = 0
var current
var keyon:bool
# Called when the node enters the scene tree for the first time
func _ready() -> void:
	Global.change.connect(room)
	Global.clicked.connect(func():
		if not visible: 
			click())

func room(door, doorback):
	audioplayer.stream = audiowalk
	audioplayer.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.captions.modulate.a == 1 or safe.visible or Global.boombox.visible:
		$"../interactables".texture = load("res://interactablesnot.png")
	else:
		$"../interactables".texture = load("res://interactables.png")
	if keyon:
		$"../interactables".texture = load("res://grab.png")
	if (len(Global.object) > 0 and not visible) or keyon:
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
		if index != prev and scale == Vector2(0.4, 0.4) and get_child(index).visible:
			audioplayer.stream = audio
			audioplayer.play()
			print("diff")
		get_child(index).scale = Vector2(1.1, 1.1)
		prev = index
	else:
		back()
		

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and visible:
			if index == -1:
				Global.emit_signal("speech", current.speech)
			elif index == 0:
				current.click()
			elif index == 2:
				current.use()
			back()

func click():
	if not Global.captions.modulate.a == 1:
		get_child(2).hide()
		get_child(0).hide()
		current = Global.object[-1]
		if current.door or current.container:
			if not current.opentexture == current.sprite.texture:
				get_child(2).show()
		if current.door:
			get_child(0).show()
			get_child(0).get_child(0).text = "Enter"
		elif current.boombox or current.safe:
			get_child(0).show()
			get_child(0).get_child(0).text = "Use"
		elif current.cassette:
			get_child(0).show()
			get_child(0).get_child(0).text = "Take"
		elif current.bed:
			get_child(0).show()
			get_child(0).get_child(0).text = "Sleep"
			
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
