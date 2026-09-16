extends Node2D

@onready var caption = $canvas/caption

func _ready() -> void:
	Global.lock = $"canvas/spinlock" 
	Global.boombox = $"canvas/boombox" 
	Global.current = $"Bedroom"
	Global.interart = load("res://interactables.png") 
	Global.inter = $canvas/interactables
	Global.light = $light
	Global.dark = $dark
