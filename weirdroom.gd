extends Sprite2D

@onready var godcon:Node2D = $front/Godcon
@onready var god:Sprite2D = $front/Godcon/God
var positions: Array[Vector2] = [Vector2(17, -55), Vector2(55, 16), Vector2(43, 107)]
@onready var front:Texture2D = load("res://darkness.png")
@onready var back:Texture2D = load("res://brokenwall.png")
@onready var keyword:PackedScene = load("res://voice.tscn")
@onready var voice:PackedScene = load("res://keyword.tscn")

@onready var timer: Timer = $Timer
@onready var seen: TextureProgressBar = $front/seen
@export var statement:Array[Dialogue]
@export var response:Array[Dialogue]
@export var safekeeping:Dictionary[String, int]
@export var image:Dictionary[String, Texture2D]
var ask = false
var tempkeeping:Array[String]

signal text(tex:String)
signal user_responded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$front/answer/Button.pressed.connect(func():
		user_responded.emit())
	$front/answer.text_submitted.connect(func(submittedtext):
		user_responded.emit())
	timer.timeout.connect(time)
	Global.texts = $front/answer
	Global.change.connect(change)
	Global.seegod.connect(func():
		if ask:
			askgod())
	movearound()
	hover()
	text.connect(texter)
	find_child("front").visibility_changed.connect(func():
		if texture == front:
			texture = back
			timer.stop()
		else:
			texture = front
			seen.value = 0
			timer.start())
	await get_tree().process_frame
	var temp = Global.load_game_settings()
	if temp.get_value("player", "awaken", false):
		$"back/Freedom end".modulate = Color(1.0, 1.0, 1.0, 1.0)
	if temp.get_value("player", "end", false):
		$"back/Enlighted end".modulate = Color(1.0, 1.0, 1.0, 1.0)
	if temp.get_value("player", "bad", false):
		$"back/bad end".modulate = Color(1.0, 1.0, 1.0, 1.0)
	
func texter(s:String):
	$front/answer.text = s
	for i in $front/answer/window/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for x in Global.found[s]:
		var voicetemp = keyword.instantiate()
		$front/answer/window/ScrollContainer/VBoxContainer.add_child(voicetemp)
		voicetemp.text = x.caption
		voicetemp.pressed.connect(func():
			var te:Array[Dialogue] = [x]
			Global.emit_signal("speech",te))
func change(current, direction):
	if name == current:
		Global.light.show()
		Global.dark.hide()
		$"../canvas/time".hide()
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
	for key in Global.data.keys():
		var i = Dialogue.new()
		i.caption = key
		i.audio = load(Global.data[key]["voice"])
		var temp:Array[Dialogue] = [i]
		Global.emit_signal("speech", temp)
		await Global.speechfinished
		$front/answer.show()
		for x in $front/answer/Answers/VBoxContainer.get_children():
			x.queue_free()
		for x in Global.found.keys():
			var voicetemp = voice.instantiate()
			$front/answer/Answers/VBoxContainer.add_child(voicetemp)
			voicetemp.text = x
			voicetemp.pressed.connect(func():
				emit_signal("text", x))
		await user_responded
		$front/answer.hide()
		for x in Global.data[key]["answers"].keys():
			if $front/answer.text.to_lower() in Global.data[key]["answers"][x].map(func(word): return word.to_lower()):
				safekeeping[x] += 1
				if x == "secret":
					Global.emit_signal("statics")
					await get_tree().create_timer(1.3).timeout
		$front/answer.text = ""
		temp = [response.pick_random()]
		Global.emit_signal("speech", temp)
		await Global.speechfinished 
		await get_tree().create_timer(0.5).timeout
	$front.hide()
	$"../light".hide()
	
	if safekeeping["ori"] >= 4:
		$"..".trigger("ori")
		texture = image["ori"]
		var temp = Global.load_game_settings()
		temp.set_value("player", "end", true)
		Global.save_game_settings(temp)
	elif safekeeping["secret"] >= 5:
		$"..".trigger("secret")
		texture = image["secret"]
		var temp = Global.load_game_settings()
		temp.set_value("player", "awaken", true)
		Global.save_game_settings(temp)
	else:
		$"..".trigger("bad")
		texture = image["bad"]
		var temp = Global.load_game_settings()
		temp.set_value("player", "bad", true)
		Global.save_game_settings(temp)
	
	
