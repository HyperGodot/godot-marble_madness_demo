extends Camera

export(NodePath) var player_ball : NodePath
onready var ball = get_node(player_ball)
onready var offset = ball.to_local(global_transform.origin)

var fCameraGoalFoV : float
var lCameraAngle : Label
var tween : Tween

func _ready():
	fCameraGoalFoV = fov
	lCameraAngle = get_tree().get_current_scene().get_node("DebugUI").get_node("CameraAngle_Real")
	tween = get_tree().get_current_scene().get_node("CameraTween")

func _process(_delta):
	# Update Camera Position
	global_transform.origin.y = ball.global_transform.origin.y + offset.y + 1.00
	global_transform.origin.z = ball.global_transform.origin.z + offset.z
	
	# Check for Camera-Related Inputs
	if Input.is_action_just_released("camera_zoom_in"):
		fCameraGoalFoV = max(5, fCameraGoalFoV - 2)
		tween.remove_all()
		tween.interpolate_property(self, "fov",
			self.fov, fCameraGoalFoV, 1,
			Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
	elif Input.is_action_just_released("camera_zoom_out"):
		fCameraGoalFoV = min(20, fCameraGoalFoV + 2)
		tween.remove_all()
		tween.interpolate_property(self, "fov",
			self.fov, fCameraGoalFoV, 1,
			Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
