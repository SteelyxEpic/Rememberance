extends Node

signal speech(text:Dictionary)
signal clicked
signal keychange(changes)
signal lightchange(names, state)
signal rotate(show:bool)
signal change(location:String, direction: bool)
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

func switch():
	if not interact.visible:
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
