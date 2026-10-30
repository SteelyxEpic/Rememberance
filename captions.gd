extends RichTextLabel

var tween:Tween
@onready var audioplayer:AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	Global.speech.connect(texting)
	Global.captions = self

func texting(captions:Array[Dialogue]):
	if not modulate.a == 1:
		show()
		modulate.a = 1
		for i in captions:
			var caption = i.caption
			if not Global.texts.visible:
				var found_words = Global.text.filter(func(word): return word.to_lower() in caption.to_lower())
				for x in found_words:
					if Global.found.has(x):
						Global.found[x].append(i)
					else:
						Global.found[x] = [i]
			var audio:AudioStreamMP3 = i.audio
			if tween:
				tween.stop()
			text = caption
			if audio:
				audioplayer.stream = audio
				audioplayer.play()
				await audioplayer.finished
			else:
				await get_tree().create_timer(1).timeout
			if i == captions[-1]:
				tween = get_tree().create_tween()
				tween.tween_property(self, "modulate:a", 0, 0.5)
				Global.emit_signal("speechfinished")
				await tween.finished
			
		hide()

func skipping():
	audioplayer.stop()
	audioplayer.emit_signal("finished")
