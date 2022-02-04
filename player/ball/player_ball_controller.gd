extends RigidBody

enum BallPhysicsMode {
	FREE_FLY,
	ENGINE_PHYSICS_ROLL,
	ENGINE_PHYSICS_LINEAR,
	PHYSICS_MAX
}

signal moved

var rolling_force : float = 10.0
var rolling_force_max : float = 50.0

var linear_force : float = 2.0

var freefly_force : float = 3.0

onready var ballInitialOrigin : Vector3 = self.translation

var ball_physics_mode : int = BallPhysicsMode.ENGINE_PHYSICS_LINEAR
var bFirstPersonCamera = false

var lVelocity : Label
var lAngularVelocity : Label
var lBallPhysicsMode : Label

func _ready():
	lVelocity = get_tree().get_current_scene().get_node("BallDebugUI").find_node("BallVelocity_Value")
	lAngularVelocity = get_tree().get_current_scene().get_node("BallDebugUI").find_node("BallAngularVelocity_Value")
	lBallPhysicsMode = get_tree().get_current_scene().get_node("BallDebugUI").find_node("BallPhysicsMode_Value")
	
	updateBallPhysicsMode()

func _process(_delta: float) -> void:
	pass
	
func resetBall() -> void:
	self.angular_velocity = Vector3(0, 0, 0)
	self.linear_velocity = Vector3(0, 0, 0)
	self.rotation = Vector3(0, 0, 0)
	ball_physics_mode = BallPhysicsMode.ENGINE_PHYSICS_LINEAR
	updateBallPhysicsMode()
	self.translation = ballInitialOrigin
	
func updateBallPhysicsMode() -> void:
	if(ball_physics_mode == BallPhysicsMode.FREE_FLY):
		lBallPhysicsMode.text = "Free Fly"
		self.angular_velocity = Vector3(0, 0, 0)
		self.rotation = Vector3(0, 0, 0)
		self.linear_velocity = Vector3(0, 0, 0)
		self.mode = RigidBody.MODE_STATIC
	elif(ball_physics_mode == BallPhysicsMode.ENGINE_PHYSICS_ROLL):
		lBallPhysicsMode.text = "Rolling"
		self.physics_material_override.friction = 1.0
		self.mode = RigidBody.MODE_RIGID
	else:
		lBallPhysicsMode.text = "Linear"
		self.physics_material_override.friction = 0.035
		self.mode = RigidBody.MODE_RIGID
	
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
			
	#if false:
	#	ballCamera.global_transform.origin = lerp(
	#		ballCamera.global_transform.origin, 
	#		global_transform.origin, 1.0
	#	)
	#	ballCamera.global_transform.origin = lerp(
	#		ballCamera.global_transform.origin, 
	#		global_transform.origin, 1.0
	#	)
	
	if Input.is_action_just_pressed("ball_cycle_physics_mode"):
		ball_physics_mode = (ball_physics_mode + 1) % BallPhysicsMode.PHYSICS_MAX
		if(ball_physics_mode == BallPhysicsMode.FREE_FLY):
			self.mode = RigidBody.MODE_STATIC
		else:
			self.mode = RigidBody.MODE_RIGID
		updateBallPhysicsMode()
	
			
	#if(ball_physics_mode == BallPhysicsMode.FREE_FLY):
	#	return
		
	if Input.is_action_pressed("ball_roll_up"):
		if(ball_physics_mode == BallPhysicsMode.ENGINE_PHYSICS_ROLL):
			angular_velocity.x = clamp(angular_velocity.x - rolling_force*delta, rolling_force_max * -1, rolling_force_max)
		elif(ball_physics_mode == BallPhysicsMode.FREE_FLY):
			self.translate( Vector3(0, 0, -freefly_force) * delta)
		else:
			linear_velocity.z -= (linear_force * delta);
	elif Input.is_action_pressed("ball_roll_down"):
		if(ball_physics_mode == BallPhysicsMode.ENGINE_PHYSICS_ROLL):
			angular_velocity.x = clamp(angular_velocity.x + rolling_force*delta, rolling_force_max * -1, rolling_force_max)
		elif(ball_physics_mode == BallPhysicsMode.FREE_FLY):
			self.translate( Vector3(0, 0, freefly_force) * delta)
		else:
			linear_velocity.z += (linear_force * delta);
			
	if Input.is_action_pressed("ball_roll_left"):
		if(ball_physics_mode == BallPhysicsMode.ENGINE_PHYSICS_ROLL):
			angular_velocity.z = clamp(angular_velocity.z + rolling_force*delta, rolling_force_max * -1, rolling_force_max)
		elif(ball_physics_mode == BallPhysicsMode.FREE_FLY):
			self.translate( Vector3(-freefly_force, 0, 0) * delta)
		else:
			linear_velocity.x -= (linear_force * delta);
	elif Input.is_action_pressed("ball_roll_right"):
		if(ball_physics_mode == BallPhysicsMode.ENGINE_PHYSICS_ROLL):
			angular_velocity.z = clamp(angular_velocity.z - rolling_force*delta, rolling_force_max * -1, rolling_force_max)
		elif(ball_physics_mode == BallPhysicsMode.FREE_FLY):
			self.translate( Vector3(freefly_force, 0, 0) * delta)
		else:
			linear_velocity.x += (linear_force * delta);
			
	if Input.is_action_pressed("ball_fly_up"):
		if(ball_physics_mode == BallPhysicsMode.FREE_FLY):
			self.translate( Vector3(0, freefly_force, 0) * delta)
	elif Input.is_action_pressed("ball_fly_down"):
		if(ball_physics_mode == BallPhysicsMode.FREE_FLY):
			self.translate( Vector3(0, -freefly_force, 0) * delta)

	#if Input.is_action_just_pressed("jump") and $FloorCheck.is_colliding():
	#	apply_impulse(Vector3(), Vector3.UP*1000)
	
	# Update Debug UI
	lVelocity.text = String(self.linear_velocity)
	lAngularVelocity.text = String(self.angular_velocity)

func _on_PlayerLocal_reset_ball() -> void:
	resetBall()

func _on_special_input_reset_ball() -> void:
	resetBall()
