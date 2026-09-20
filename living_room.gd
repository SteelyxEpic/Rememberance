extends Node2D

@onready var caption = $canvas/caption
@onready var button_2: Button = $Weirdroom/back/mainscreen/Button2
@export var Godspeech:Array[Dialogue]
@export var Godspeech2:Array[Dialogue]
@export var Godspeech3:Array[Dialogue]
@export var Answers:Array[Dialogue]
@export var Answersindex:Dictionary[String, Vector2]

func _ready() -> void:
	$Weirdroom/back/mainscreen/Button.pressed.connect(func():
		get_tree().quit())
	Global.lock = $"canvas/spinlock" 
	Global.boombox = $"canvas/boombox" 
	Global.current = $"Weirdroom"
	Global.interart = load("res://interactables.png") 
	Global.inter = $canvas/interactables
	Global.interact = $canvas/interact
	Global.light = $light
	Global.dark = $dark
	button_2.pressed.connect(func():
		$Weirdroom/back/mainscreen.hide()
		Global.emit_signal("speech", Godspeech)
		await Global.speechfinished
		$Weirdroom/back/space.show()
		await $Weirdroom/back.visibility_changed
		$Weirdroom/back/space.hide()
		await Global.seegod
		Global.emit_signal("speech", Godspeech2)
		await Global.speechfinished
		Global.emit_signal("change", "Bedroom",true)
		await get_tree().create_timer(0.6).timeout
		Global.emit_signal("speech", Godspeech3)
		$Weirdroom.ask = true
		)
		


func _on_ambience_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Ambience")
	var db_val = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db_val)


func _on_voices_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	var db_val = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db_val)
