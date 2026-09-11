extends Node2D

@onready var lock:Sprite2D = $lock
var holdingdown:bool
var temp:float
var answer:String
var actual:String = "1452"
var safe

func hidenow():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if not holdingdown:
				holdingdown = true
				temp = lock.global_position.angle_to_point(get_global_mouse_position())
			var location = lock.global_position.angle_to_point(get_global_mouse_position())
			lock.rotation = location - temp
			
		elif holdingdown:
			holdingdown = false
			var temp = lock.rotation_degrees/45
			if round(temp) != 0:
				answer += (str(roundi(temp)) if round(temp) > 0 else str(roundi(temp) + 8)) 
			if len(answer) == len(actual):
				if answer == actual:
					safe.open()
					print("correct!")
				else:
					print("Wrong!")
				answer = ""
			var tween:Tween = get_tree().create_tween()
			tween.tween_property(lock,"rotation_degrees", 0, abs(lock.rotation_degrees)/720)
		
