class_name BasicNode

extends Node2D

@export var StoredPower = 0

var ConnectedNodes = []
var ConnectedWires = []

func send(data):
	
	for i in ConnectedNodes.size():
		print(data.Map)
		if data.Map.has(self):
			var handoff_node = data.Map[data.Map.find(self) + 1]
			if ConnectedNodes.has(handoff_node) && handoff_node != data.From:
				
				ConnectedNodes[ConnectedNodes.find(handoff_node)].send(data)
				
				pulse_wire(handoff_node)

func pulse_wire(connectedto):
	for i in ConnectedWires.size():
		
		if ConnectedWires[i].WiredTo or ConnectedWires[i].WiredFrom == self and ConnectedWires[i].WiredTo or ConnectedWires[i].WiredFrom == connectedto:
			ConnectedWires[i].pulse()


func connectNode(node):
	print("CN", self, ConnectedNodes, node)
	if !node == null:
		if !ConnectedNodes.has(node):
			var WireScene = load("res://nodes/wire/wire.tscn").instantiate()
			WireScene.WiredFrom = self
			WireScene.WiredTo = node
			get_parent().add_child.call_deferred(WireScene)
			ConnectedWires.append(WireScene)
			ConnectedNodes.append(node)
			node.connectNode(self)
			print("SC",self, node)
			NavBus.connect_nodes(self, node)
			

	else:
		print("duplicate node connection", node)

func disconnectNode(node):
	if ConnectedNodes.has(node):
		ConnectedNodes.erase(node)
		NavBus.disconnect_nodes(self, node)
	else:
		print("invalid node disconnection")
