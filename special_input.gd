extends Node

var bDebugPaused : bool = false
var mouseModeBackup
var UINode = null

signal reset_ball()

func _ready():
	bDebugPaused = false
	get_tree().paused = false
	
func HandleMouseToggle():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		mouseModeBackup = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(mouseModeBackup)
		
func CheckAndUpdateUINode():
	if(UINode == null):
		UINode = get_tree().get_current_scene().find_node("Menu_Main")

func _process(_delta):
	if Input.is_action_just_pressed("debug_pause"):
		bDebugPaused = !bDebugPaused
		if bDebugPaused:
			get_tree().paused = true
		else:
			get_tree().paused = false
	if Input.is_action_just_pressed("ui_cancel"):
		# Toggle UI
		CheckAndUpdateUINode()
		if(UINode._getIsMenuShowing() ):
			UINode.hideUI()
		else:
			UINode.resetUI()
			UINode.showUI()
	if Input.is_action_just_pressed("restart_level"):
		# get_tree().reload_current_scene()
		emit_signal("reset_ball")
