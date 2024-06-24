extends Node2D

var Powered = 0

var ConnectedNodes = {}

var RequestForm = {
	"To":"Power",
	"Power":1
	}

func _ready():
	Utils.Demanders.append(self)

func _physics_process(delta):
	if Powered:
		$ColorRect.color.b += 1

func getPower():
	if request():
		Powered = 1
	else:
		Powered = 0

func request():
	for i in ConnectedNodes.size():
		if ConnectedNodes[i].is_in_group("relay"):
			ConnectedNodes[i].send(RequestForm)

func connectNode(node):
	print("turret connected to")
	
	var WireScene = load("res://wire.tscn").instantiate()
	WireScene.WiredFrom = self
	WireScene.WiredTo = node
	get_parent().add_child(WireScene)
	
	ConnectedNodes[ConnectedNodes.size()] = node
	
	print(ConnectedNodes)

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		connectNode(prospectiveNode)
