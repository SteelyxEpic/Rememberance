extends Node

signal speech(text:Dictionary)
signal clicked
signal keychange(changes)
signal lightchange(names, state)
signal rotate(show:bool)
signal change(location:String, direction: bool)
signal seegod
signal speechfinished
signal statics
signal staticchange(intensity:float)
const SAVE_PATH = "user://settings.cfg"
var inter:Sprite2D
var interart:Texture2D
var locked:Dictionary = {"Locked": load("res://locked.mp3")}
var nokey:Dictionary = {"I don't have key for this": load("res://locked.mp3")}
var toodark:Dictionary = {"It's too dark to read anything": load("res://toodark.mp3")}
var toodarkpic:Dictionary = {"It's too dark to see anything": load("res://seeno.mp3")}
var captions: RichTextLabel
var inventory:Array[String]
var object:Array
var keys: int:
	set(new_value):
		emit_signal("keychange", new_value - keys)
		keys = new_value
var cassettes: Dictionary[String, Array]
@onready var current:Node2D
@onready var lock: Node2D
@onready var boombox: Node2D
@onready var light: Sprite2D
@onready var dark: Sprite2D
@onready var interact:Node2D
@onready var texts:LineEdit
var data
var text
var found: Dictionary

func _ready() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	config.set_value("audio", "sfx", config.get_value("audio", "sfx", 0.8))
	config.set_value("audio", "bg", config.get_value("audio", "bg", 0.8))
	config.set_value("player", "awaken", config.get_value("player", "awaken", false))
	config.set_value("player", "bad", config.get_value("player", "bad", false))
	config.set_value("player", "end", config.get_value("player", "end", false))
	save_game_settings(config)
	var file = FileAccess.open("res://texts.json", FileAccess.READ)
	var json_text = file.get_as_text()
	var json = JSON.new()
	json.parse(json_text)
	var temp = json.data
	text = temp["Text"]
	temp.erase("Text")
	data = temp


func save_game_settings(file: ConfigFile):
	var error = file.save(SAVE_PATH)
	if error != OK:
		print("Failed to save config file. Error code: ", error)
		

func load_game_settings() -> ConfigFile:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	# If the file doesn't exist or fails to open, abort
	if error != OK:
		print("No save file found or failed to load. Using defaults.")
		return
	
	return config
	
func switch():
	print(texts.visible)
	if not interact.visible and not texts.visible:
		if not current.find_child("back").visible:
			current.find_child("back").show()
			current.find_child("front").hide()
		else:
			current.find_child("front").show()
			current.find_child("back").hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch") and current and inter.texture == interart:
		switch()
func mouse(obj, remove):
	if remove:
		object.erase(obj)
	else:
		object.append(obj)
