extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	var temp = $"../../safe".answer
	text ="Y - " + temp[3] + "\nR - " + temp[1] + "\nB - " + temp[2] + "\nW - " + temp[0]
