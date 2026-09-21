extends Area2D # Changed from Sprite2D

@export var speech:Array[Dialogue]
@export var opentexture: Texture2D = load("res://safeopen.png")
@onready var sprite: Sprite2D = get_child(0)
@onready var rewards: Node2D = get_child(-1)
var original: Texture2D
@export var answer = "1234"
@export var safe:bool = false
@export var door:String = ""
@export var doorback:bool
@export var container:bool
@export var boombox:bool
@export var direct:bool
@export var cassette:Array[Dialogue]
var cassettecolor
@export var note:bool
@export var picture:bool
@export var recorder:bool
@export var bed:bool
@onready var beep:AudioStreamMP3 = load("res://voicelines/cassette2/beep.mp3")

func _ready() -> void:
	answer = ""
	for i in range(4):
		answer += str(randi_range(1, 7))
	original = get_child(0).texture
	input_event.connect(_on_input_event)
	if recorder:
		var tem = Dialogue.new()
		tem.audio =  beep
		tem.caption = ""
		speech.insert(0, tem)
	mouse_entered.connect(func():
		if (safe or container) and rewards.visible:
			return
		Global.mouse(self, false))
	mouse_exited.connect(func():
		if (safe or container) and rewards.visible:
			return
		Global.mouse(self, true))
	if cassette:
		cassettecolor = Color8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255))
		modulate = cassettecolor
		
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if (safe or container) and rewards.visible:
			return
		if direct:
			Global.emit_signal("change", door,doorback)
			return
		if recorder:
			Global.emit_signal("speech", speech)
			return
		if note:
			if Global.light.visible:
				Global.emit_signal("speech", speech)
			else:
				var temp:Array[Dialogue]
				for i in Global.toodark.keys():
					var temps = Dialogue.new()
					temps.caption = i
					temps.audio = Global.toodark[i]
					temp.append(temps)
				Global.emit_signal("speech", temp)
			return
		if picture:
			if Global.light.visible:
				Global.emit_signal("speech", speech)
			else:
				var temp:Array[Dialogue]
				for i in Global.toodarkpic.keys():
					var temps = Dialogue.new()
					temps.caption = i
					temps.audio = Global.toodarkpic[i]
					temp.append(temps)
				Global.emit_signal("speech", temp)
			return
		Global.emit_signal("clicked")
			
func click():
	if safe:
		rewards = $Rewards 
		Global.lock.safe = self
		Global.lock.show()
		Global.lock.actual = answer
		Global.lock.answer = ""
	elif door != "":
		if sprite.texture == opentexture:
			Global.emit_signal("change", door,doorback)
		else:
			var temp:Array[Dialogue]
			for i in Global.locked.keys():
				var temps = Dialogue.new()
				temps.caption = i
				temps.audio = Global.locked[i]
				temp.append(temps)
			Global.emit_signal("speech", temp)
	elif boombox:
		Global.boombox.show()
	elif cassette:
		Global.cassettes[name] = [cassette, cassettecolor]
		hide()
	elif bed:
		Global.emit_signal("change", "Weirdroom", true)

func use():
	if safe:
		pass
	elif sprite.texture != opentexture:
		if door != "" or container: 
			if Global.keys > 0:
				Global.keys -= 1
				sprite.texture = opentexture
				if container:
					Global.mouse(self, true)
					rewards.show()
			else:
				var temp:Array[Dialogue]
				for i in Global.nokey.keys():
					var temps = Dialogue.new()
					temps.caption = i
					temps.audio = Global.nokey[i]
					temp.append(temps)
				Global.emit_signal("speech", temp)
				

func open():
	Global.lock.hide()
	rewards.show()
	sprite.texture = opentexture # Changed to point to the child sprite
