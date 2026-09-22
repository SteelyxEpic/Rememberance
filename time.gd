extends RichTextLabel
@onready var timer: Timer = $Timer
@onready var audio: AudioStreamMP3 = preload("res://alarm.mp3")
var timeminute = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(next)

func next():
	timeminute += 1
	var hour = floor(timeminute/60)
	text = "%02d" % hour + ":%02d" % (timeminute - (hour * 60))
	if hour == 24:
		timer.stop()
		$"../sfx".stream = audio
		$"../sfx".play()
		await $"../sfx".finished
		Global.emit_signal("change", "Weirdroom", true)
