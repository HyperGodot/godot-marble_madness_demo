extends RigidBody

var rolling_force = 10
var bFirstPersonCamera = false
var bDebugPaused : bool = false
var ballCameraOriginalOrigin : Vector3
var fCameraGoalFoV : float = 10

var vBallCameraRotation : Vector3

var ballCamera : Camera
var lVelocity : Label
var lCameraAngle : Label

func _ready():
	ballCamera = $ballCamera
	if !ballCamera:
		ballCamera = get_tree().get_current_scene().get_node("Position3D").get_node("ballCamera")
	if !ballCamera:
		ballCamera = get_tree().get_current_scene().get_node("ballCamera")
	if !ballCamera:
		ballCamera = get_node("ballCamera")
	ballCamera.set_as_toplevel(true)
	lVelocity = get_tree().get_current_scene().get_node("DebugUI").get_node("Velocity_Real")
	lCameraAngle = get_tree().get_current_scene().get_node("DebugUI").get_node("CameraAngle_Real")
	# Backup Camera Transform
	if ballCamera:
		ballCameraOriginalOrigin = ballCamera.global_transform.origin
		vBallCameraRotation = ballCamera.rotation

func _process(delta: float) -> void:
	ballCamera.fov = move_toward(ballCamera.fov, fCameraGoalFoV, 8 * delta)
	

func _physics_process(delta: float) -> void:
	
	ballCamera.translate( Vector3(0.001, 0.0, 0.0))
	#if ballCamera:
	#	ballCamera.rotation = (vBallCameraRotation)
		
	if Input.is_action_just_pressed("camera_toggle_fps"):
		if bFirstPersonCamera == true:
			bFirstPersonCamera = false
			ballCamera.global_transform.origin = ballCameraOriginalOrigin
		else:
			bFirstPersonCamera = true
			
	if bDebugPaused:
		return
			
	if false:
		ballCamera.global_transform.origin = lerp(
			ballCamera.global_transform.origin, 
			global_transform.origin, 1.0
		)
		ballCamera.global_transform.origin = lerp(
			ballCamera.global_transform.origin, 
			global_transform.origin, 1.0
		)
		
	if Input.is_action_just_released("camera_zoom_in"):
		fCameraGoalFoV += -2
	elif Input.is_action_just_released("camera_zoom_out"):
		fCameraGoalFoV += 2
	
	#$FloorCheck.global_transform.origin = global_transform.origin
	if Input.is_action_pressed("ball_roll_up"):
		angular_velocity.x -= rolling_force*delta
	elif Input.is_action_pressed("ball_roll_down"):
		angular_velocity.x += rolling_force*delta
	if Input.is_action_pressed("ball_roll_left"):
		angular_velocity.z += rolling_force*delta
	elif Input.is_action_pressed("ball_roll_right"):
		angular_velocity.z -= rolling_force*delta

	#if Input.is_action_just_pressed("jump") and $FloorCheck.is_colliding():
	#	apply_impulse(Vector3(), Vector3.UP*1000)
	
	# Update Debug UI
	lVelocity.text = String(self.linear_velocity)
	lCameraAngle.text = String(self.rotation)
