extends RigidBody

var rolling_force = 10
var rolling_force_max : float = 50
var bFirstPersonCamera = false
var bDebugPaused : bool = false
var ballCameraOriginalOrigin : Vector3

var lVelocity : Label
var lAngularVelocity : Label

func _ready():
	lVelocity = get_tree().get_current_scene().get_node("DebugUI").get_node("BallVelocity_Value")
	lAngularVelocity = get_tree().get_current_scene().get_node("DebugUI").get_node("BallAngularVelocity_Value")

func _process(_delta: float) -> void:
	pass
	
func checkAngularVelocity(delta : float, angVelocity : float, bAdd : bool) -> float:
	if bAdd:
		angVelocity = angVelocity + rolling_force*delta
	else:
		angVelocity = angVelocity - rolling_force*delta
		
	var cappedVelocity = min(rolling_force_max, abs(angVelocity) )
	if (angVelocity < 0):
		return cappedVelocity * -1
	else:
		return cappedVelocity

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("camera_toggle_fps"):
	#	if bFirstPersonCamera == true:
	#		bFirstPersonCamera = false
	#		ballCamera.global_transform.origin = ballCameraOriginalOrigin
	#	else:
	#		bFirstPersonCamera = true
			
	if bDebugPaused:
		return
			
	#if false:
	#	ballCamera.global_transform.origin = lerp(
	#		ballCamera.global_transform.origin, 
	#		global_transform.origin, 1.0
	#	)
	#	ballCamera.global_transform.origin = lerp(
	#		ballCamera.global_transform.origin, 
	#		global_transform.origin, 1.0
	#	)
		
	
	
	#$FloorCheck.global_transform.origin = global_transform.origin
	if Input.is_action_pressed("ball_roll_up"):
		# angular_velocity.x = checkAngularVelocity(delta, angular_velocity.x, false)
		angular_velocity.x = clamp(angular_velocity.x - rolling_force*delta, rolling_force_max * -1, rolling_force_max)
	elif Input.is_action_pressed("ball_roll_down"):
		# angular_velocity.x = checkAngularVelocity(delta, angular_velocity.x, true)
		angular_velocity.x = clamp(angular_velocity.x + rolling_force*delta, rolling_force_max * -1, rolling_force_max)
	if Input.is_action_pressed("ball_roll_left"):
		#angular_velocity.z = checkAngularVelocity(delta, angular_velocity.z, true)
		angular_velocity.z = clamp(angular_velocity.z + rolling_force*delta, rolling_force_max * -1, rolling_force_max)
	elif Input.is_action_pressed("ball_roll_right"):
		#angular_velocity.z = checkAngularVelocity(delta, angular_velocity.z, false)
		angular_velocity.z = clamp(angular_velocity.z - rolling_force*delta, rolling_force_max * -1, rolling_force_max)

	#if Input.is_action_just_pressed("jump") and $FloorCheck.is_colliding():
	#	apply_impulse(Vector3(), Vector3.UP*1000)
	
	# Update Debug UI
	lVelocity.text = String(self.linear_velocity)
	lAngularVelocity.text = String(self.angular_velocity)
