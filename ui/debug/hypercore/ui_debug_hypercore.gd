extends Control

signal gossip_update_rate_changed(seconds)

onready var lGossipUpdateRate = $HypercoreDebugPanel/HypercoreDebugContainer/GossipUpdateRate

var hypergateway : HyperGateway


func _ready():
	pass

func _process(_delta):
	pass


func _on_GatewayStartStopButton_button_up():
	if(!hypergateway):
		# TODO : Make this find a potential HyperGateway node based on classtype, and not assuming scene root node name is Spatial.
		hypergateway = get_tree().root.get_node("Spatial").find_node("HyperGateway")
	if(hypergateway):
		if( hypergateway.getIsGatewayRunning() ):
			hypergateway.stop()
		else:
			hypergateway.start()

func _on_GossipUpdateRate_Value_value_changed(value : float):
	lGossipUpdateRate.text = "Gossip in " + String(value) + " Seconds: "
	emit_signal("gossip_update_rate_changed", value)
