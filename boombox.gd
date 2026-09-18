extends Node2D

@onready var cassetteprefab:PackedScene = load("res://cassettes.tscn")
var openTween: Tween
var closeTween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(func():
		for i in $cassette.get_children():
			i.queue_free()
		if visible:
			var y = 0
			for i in Global.cassettes.keys():
				var temp:TextureButton = cassetteprefab.instantiate()
				$cassette.add_child(temp)
				temp.position = Vector2(350, y)
				temp.y = y
				y += 75
				temp.speech = Global.cassettes[i][0]
				temp.modulate = Global.cassettes[i][1]
				)


func hidenow():
	hide()
