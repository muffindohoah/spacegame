extends Node2D

var ConnectedNodes = {}

var ReturnForm = {
	To
	"Power":
	
}

func _ready():
	Utils.Suppliers.append(self)
	updateDistances()

func send(data):
	call_deferred("receiveRequest", data)

func receiveRequest():
	pass

func returnRequest():
	pass

func updateDistances():
	for i in ConnectedNodes.size():
		ConnectedNodes[i].setDistanceFrom([self], 0)
		print("chatty")

func connectNode(node):
	print("gen connected to")
	
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
		updateDistances()


func _on_timer_timeout():
	updateDistances()
