extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene("res://levels/scenes/level_0.tscn")
	# emit signal player_request_join


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
