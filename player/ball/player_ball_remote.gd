extends "res://player/ball/player_ball.gd"

func update_position(new_translation : Vector3, new_rotation : Vector3, new_velocity_linear : Vector3, new_velocity_angular : Vector3):
	self.translation = new_translation
	self.rotation = new_rotation
	self.linear_velocity = new_velocity_linear
	self.angular_velocity = new_velocity_angular

func _physics_process(_delta):
	pass
