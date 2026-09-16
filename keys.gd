extends RichTextLabel

@onready var audioplayer = $AudioStreamPlayer2D
@onready var gain = load("res://alexzavesa-clinking-coins-7-468427.mp3")
@onready var loss = load("res://unlock.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.keychange.connect(update)

func update(change):
	text = "x " + str(Global.keys + change)
	if change > 0:
		audioplayer.stream = gain
	else:
		audioplayer.stream = loss
	audioplayer.stop()
	audioplayer.play()
