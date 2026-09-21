extends Sprite2D

@onready var godcon:Node2D = $front/Godcon
@onready var god:Sprite2D = $front/Godcon/God
var positions: Array[Vector2] = [Vector2(17, -55), Vector2(55, 16), Vector2(43, 107)]
@onready var front:Texture2D = load("res://weirdroom.png")
@onready var back:Texture2D = load("res://brokenwall.png")
@onready var timer: Timer = $Timer
@onready var seen: TextureProgressBar = $front/seen
@export var statement:Array[Dialogue]
@export var ques:Array[Dialogue]
@export var response:Array[Dialogue]
@export var answer:Dictionary[String, String]
@export var safekeeping:Dictionary[String, int]
var ask = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(time)
	Global.change.connect(change)
	Global.seegod.connect(func():
		if ask:
			askgod())
	movearound()
	hover()
	
	find_child("front").visibility_changed.connect(func():
		if texture == front:
			texture = back
			timer.stop()
		else:
			texture = front
			seen.value = 0
			timer.start())

func change(current, direction):
	if name == current:
		Global.current = self
		show()
		if direction:
			find_child("front").hide()
			find_child("back").show()
			texture = back
		else:
			find_child("front").show()
			find_child("back").hide()
			texture = front
	else:
		hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func movearound():
	while true:
		var move_tween = get_tree().create_tween()
		var xoffset = 70 * (-1 if randi_range(0, 1) == 0 else 1)
		var temp: Vector2 = positions.pick_random()
		temp.x += xoffset
		move_tween.tween_property(godcon, "position", temp, 3)
		await get_tree().create_timer(3.5).timeout

func hover():
	while true:
		var hover_tween = get_tree().create_tween()
		hover_tween.tween_property(god, "position:y", 15, 3)
		await get_tree().create_timer(3).timeout
		hover_tween.stop()
		hover_tween = get_tree().create_tween()
		hover_tween.tween_property(god, "position:y", -15, 3)
		await get_tree().create_timer(3).timeout
	
func time():
	seen.show()
	if seen.value == 100:
		timer.stop()
		seen.hide()
		Global.emit_signal("seegod")
	seen.value += 5
func askgod():
	Global.emit_signal("speech", statement)
	await Global.speechfinished
	await get_tree().create_timer(0.5).timeout
	for i in ques:
		var temp:Array = [i]
		Global.emit_signal("speech", temp)
		await Global.speechfinished
		$front/answer.show()
		await $front/answer/Button.pressed
		if $front/answer.text.to_lower() in answer:
			safekeeping[answer[$front/answer.text.to_lower()]] += 1
		temp = [response.pick_random()]
		Global.emit_signal("speech", temp)
		await Global.speechfinished 
		await get_tree().create_timer(0.5).timeout
	if safekeeping["ori"] >= 4:
		$"..".trigger("ori")
	elif safekeeping["secret"] >= 3:
		$"..".trigger("secret")
	else:
		$"..".trigger("bad")
	
	
