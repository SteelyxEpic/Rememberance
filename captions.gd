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
				await tween.finished
			
		hide()
