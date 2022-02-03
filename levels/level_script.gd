extends Node

# TODO : Make Debug UI dynamic and not hardcoded in the core Hyper scripts.
onready var hyperdebugui : Control = $HyperGodotDebugUI
onready var hyperdebugui_gateway_startstop_button : Button = $HyperGodotDebugUI/HypercoreDebugPanel/HypercoreDebugContainer/GatewayStartStopButton

onready var gateway : HyperGateway = $HyperGodot/HyperGateway
onready var gossip : HyperGossip = $HyperGodot/HyperGossip

onready var lGatewayStatus : Control = hyperdebugui.find_node("GatewayStatus_Value")
onready var lGossipURL : Control = hyperdebugui.find_node("GossipURL_Value")

onready var player_local : RigidBody = $Players/PlayerLocal

onready var gossip_event_timer : Timer = $HyperGodot/GossipEventTimer

const knownPlayers = {}

const EVENT_PLAYER_POSITION = 'player_position'

var RemotePlayer = preload("res://player/ball/player_ball_remote.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	# gossip = get_tree().get_current_scene().get_node("HyperGodot").get_node("HyperGossip")
	pass
	
func _perform_setup():
	gossip.start_listening()
	
func updateGatewayStatus(_pid : int) -> void:
	if gateway.getIsGatewayRunning():
		lGatewayStatus.text = "Listening on Port " + String(gateway.port) + " (PID " + String(_pid) + ")"
		lGossipURL.text = gossip.url
		hyperdebugui_gateway_startstop_button.text = "Stop Gateway"
	else:
		lGatewayStatus.text = "Not Running"
		lGossipURL.text = "N/A"
		hyperdebugui_gateway_startstop_button.text = "Start Gateway"
	
func _on_HyperGossip_listening(_extension_name):
	print('Started listening on events')
	# Tell everyone we exist!
	_broadcast_player()
	
func _on_HyperGossip_event(type, data, from):
	# print("Event ", type, " ", from)
	if type == EVENT_PLAYER_POSITION:
		_on_remote_player_moved(data, from)

func _on_HyperGateway_started_gateway(_pid : int):
	if !gateway:
		gateway = get_tree().get_current_scene().get_node("HyperGodot").get_node("HyperGateway")
	if !gossip:
		gossip = get_tree().get_current_scene().get_node("HyperGodot").get_node("HyperGossip")
	if !hyperdebugui:
		hyperdebugui = get_tree().get_current_scene().get_node("HyperGodotDebugUI")
	if !hyperdebugui_gateway_startstop_button:
		hyperdebugui_gateway_startstop_button = hyperdebugui.find_node("GatewayStartStopButton")
	if !lGatewayStatus:
		lGatewayStatus = hyperdebugui.find_node("GatewayStatus_Value")
	updateGatewayStatus(_pid)
	_perform_setup()
	
func _on_HyperGateway_stopped_gateway():
	updateGatewayStatus(0)
	
func _on_GossipEventTimer_timeout():
	if gateway.getIsGatewayRunning():
		_broadcast_player()

func get_player_object(id):
	if knownPlayers.has(id): return knownPlayers[id]

	var remotePlayer = RemotePlayer.instance()
	knownPlayers[id] = remotePlayer

	add_child(remotePlayer)
	_broadcast_player()

	return remotePlayer
	
func _broadcast_player():
	var translation : Vector3 = player_local.translation
	var rotation : Vector3 = player_local.rotation_degrees
	var velocity_linear : Vector3 = player_local.linear_velocity
	var velocity_angular : Vector3 = player_local.angular_velocity
	
	var data = {
		#"profile": profile,
		"translation": {
			"x": translation.x,
			"y": translation.y,
			"z": translation.z
		},
		"rotation": {
			"x": rotation.x,
			"y": rotation.y,
			"z": rotation.z
		},
		"velocity_linear": {
			"x": velocity_linear.x,
			"y": velocity_linear.y,
			"z": velocity_linear.z
		},
		"velocity_angular": {
			"x": velocity_angular.x,
			"y": velocity_angular.y,
			"z": velocity_angular.z
		}
	}
	# print('Broadcasting', data)
	gossip.broadcast_event(EVENT_PLAYER_POSITION, data)

func _on_remote_player_moved(positionData, id):
	# print('Moving player', id, " ", positionData)
	var remotePlayer = get_player_object(id)

	var translation : Vector3 = Vector3(positionData.translation.x, positionData.translation.y, positionData.translation.z)
	var rotation : Vector3 = Vector3(positionData.rotation.x, positionData.rotation.y, positionData.rotation.z)
	var velocity_linear : Vector3 = Vector3(positionData.velocity_linear.x, positionData.velocity_linear.y, positionData.velocity_linear.z)
	var velocity_angular : Vector3 = Vector3(positionData.velocity_angular.x, positionData.velocity_angular.y, positionData.velocity_angular.z)
	
	remotePlayer.update_position(
		translation,
		rotation,
		velocity_linear,
		velocity_angular
	)

func _on_PlayerLocal_moved():
	_broadcast_player()


func _on_HyperGodotDebugUI_position_update_rate_changed(seconds : float):
	gossip_event_timer.wait_time = seconds
	gossip_event_timer.start(seconds)
