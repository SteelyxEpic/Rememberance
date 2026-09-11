extends RichTextLabel

var tween:Tween
@onready var audioplayer:AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	Global.speech.connect(texting)

func texting(captions):
	if not visible:
		show()
		modulate.a = 1
		var keys = captions.keys()
		keys.reverse()
		for i in range(keys.size()):
			var caption = keys[i]
			var audio:AudioStreamMP3 = captions[caption]
			if tween:
				tween.stop()
			text = caption
			if audio:
				audioplayer.stream = audio
				audioplayer.play()
				await audioplayer.finished
			else:
				await get_tree().create_timer(1).timeout
			if i == keys.size() - 1:
				tween = get_tree().create_tween()
				tween.tween_property(self, "modulate:a", 0, 0.5)
				await tween.finished
			
		hide()
