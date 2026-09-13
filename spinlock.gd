extends Node2D

@onready var lock:Sprite2D = $lock
@onready var audio:AudioStreamMP3 = load("res://click.mp3")
@onready var unlockaudio:AudioStreamMP3 = load("res://unlock.mp3")
@onready var audioplayer:AudioStreamPlayer2D = $AudioStreamPlayer2D
var holdingdown:bool
var temp:float
var answer:String
var actual:String = "1452"
var safe
var current: int = 0

func hidenow():
	hide()
func reset():
	answer = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if not holdingdown:
				holdingdown = true
				temp = lock.global_position.angle_to_point(get_global_mouse_position())
			var location = lock.global_position.angle_to_point(get_global_mouse_position())
			lock.rotation = location - temp
			var temp = abs(roundi(lock.rotation_degrees/45))
			if temp != current:
				current = temp
				audioplayer.stream = audio
				audioplayer.stop()
				audioplayer.play()
			
		elif holdingdown:
			holdingdown = false
			current = 0
			var temp = lock.rotation_degrees/45
			if round(temp) != 0:
				answer += (str(roundi(temp)) if round(temp) > 0 else str(roundi(temp) + 8)) 
			if len(answer) == len(actual):
				if answer == actual:
					safe.open()
					audioplayer.stream = unlockaudio
					audioplayer.stop()
					audioplayer.play()
					print("correct!")
				else:
					print("Wrong!")
				answer = ""
			var tween:Tween = get_tree().create_tween()
			tween.tween_property(lock,"rotation_degrees", 0, abs(lock.rotation_degrees)/720)
		
