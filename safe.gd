extends Area2D # Changed from Sprite2D

@onready var safeopen: Texture2D = load("res://safeopen.png")
# You may need to adjust this path depending on where your lock is now located
@onready var lock: Node2D = $"../spinlock" 
@onready var sprite: Sprite2D = $Safe # Reference your child sprite
@onready var rewards: Node2D = $Rewards # Reference your child sprite
@export var answer = "1234"

func open():
	lock.hide()
	rewards.show()
	sprite.texture = safeopen # Changed to point to the child sprite

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not rewards.visible:
		lock.safe = self
		lock.show()
		lock.actual = answer
		lock.answer = ""
