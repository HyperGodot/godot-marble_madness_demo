extends Spatial

var ballCamera : Camera
var ball : RigidBody

signal player_request_join


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Attach Camera to Player Ball
	ball = get_tree().get_current_scene().get_node("player_ball")
	ballCamera = get_tree().get_current_scene().get_node("Camera")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
