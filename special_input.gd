extends Node

var bDebugPaused : bool = false

signal reset_ball()

func _ready():
	bDebugPaused = false
	get_tree().paused = false

func _process(_delta):
	if Input.is_action_just_pressed("debug_pause"):
		bDebugPaused = !bDebugPaused
		if bDebugPaused:
			get_tree().paused = true
		else:
			get_tree().paused = false
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart_level"):
		# get_tree().reload_current_scene()
		emit_signal("reset_ball")
