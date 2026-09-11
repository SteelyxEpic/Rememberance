extends Node

var inventory:Array[String]
var object:Array
@onready var current:Node2D = $"../living room/Saferoom"
@onready var lock: Node2D = $"../living room/spinlock" 
signal speech(text:Dictionary)
signal clicked

func switch():
	if current.find_child("front").visible:
		current.find_child("back").show()
		current.find_child("front").hide()
	else:
		current.find_child("front").show()
		current.find_child("back").hide()

func mouse(obj, remove):
	if remove:
		object.erase(obj)
	else:
		object.append(obj)
