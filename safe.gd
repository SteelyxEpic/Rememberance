extends Area2D

@onready var safeopen: Texture2D = load("res://safeopen.png")

@onready var sprite: Sprite2D = $Safe
@onready var rewards: Node2D = $Rewards 
@export var speech:Dictionary[String, AudioStreamMP3]
@export var answer = "1234"

func _ready() -> void:
	input_event.connect(_on_input_event)
	mouse_entered.connect(func():
		if not rewards.visible:
			Global.mouse(self, false))
	mouse_exited.connect(func():
		if not rewards.visible:
			Global.mouse(self, true))


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not rewards.visible:
		Global.emit_signal("clicked")

func click():
	Global.lock.safe = self
	Global.lock.show()
	Global.lock.actual = answer
	Global.lock.answer = ""

func open():
	Global.lock.hide()
	rewards.show()
	sprite.texture = safeopen # Changed to point to the child sprite
