extends Node2D

@onready var caption = $canvas/caption

func _ready() -> void:
	Global.lock = $"canvas/spinlock" 
	Global.current = $"Bedroom" 
