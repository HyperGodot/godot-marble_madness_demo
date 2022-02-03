extends Control

signal toggle_hypergateway_startstop(start)

var hypergateway : HyperGateway


func _ready():
	# Find Potential HyperGateway Node
	hypergateway = get_tree().root.find_node("HyperGateway")
	if(hypergateway):
		hypergateway.start()

func _process(_delta):
	hypergateway = get_tree().root.find_node("HyperGateway")
	if(hypergateway):
		hypergateway.start()


func _on_GatewayStartStopButton_button_up():
	if(!hypergateway):
		# TODO : Make this find a potential HyperGateway node based on classtype, and not assuming scene root node name is Spatial.
		hypergateway = get_tree().root.get_node("Spatial").find_node("HyperGateway")
	if(hypergateway):
		if( hypergateway.getIsGatewayRunning() ):
			hypergateway.stop()
		else:
			hypergateway.start()
