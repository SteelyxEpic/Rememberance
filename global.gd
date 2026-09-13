extends Node

signal speech(text:Dictionary)
signal clicked
signal keychange
signal rotate(show:bool)
signal change(location:String, direction: bool)
var locked:Dictionary = {"Locked": load("res://unlock.mp3")}
var nokey:Dictionary = {"I don't have key for this": load("res://unlock.mp3")}
var captions: RichTextLabel
var inventory:Array[String]
var object:Array
var keys: int:
	set(new_value):
		keys = new_value
		emit_signal("keychange")
var cassettes: Dictionary[String, Array]
@onready var current:Node2D
@onready var lock: Node2D

func switch():
	if current.find_child("front").visible:
		current.find_child("back").show()
		current.find_child("front").hide()
	else:
		current.find_child("front").show()
		current.find_child("back").hide()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch") and current:
		switch()
func mouse(obj, remove):
	if remove:
		object.erase(obj)
	else:
		object.append(obj)
