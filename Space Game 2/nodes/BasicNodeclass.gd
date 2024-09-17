class_name BasicNode

extends Node2D

@export var StoredPower = 0

var ConnectedNodes = []
 
func connectNode(node):
	print(ConnectedNodes, node)
	if !node == null:
		if !ConnectedNodes.has(node):
			var WireScene = load("res://nodes/wire/wire.tscn").instantiate()
			WireScene.WiredFrom = self
			WireScene.WiredTo = node
			get_parent().add_child.call_deferred(WireScene)
			ConnectedNodes.append(node)
			node.connectNode(self)

	else:
		print("duplicate node connection", node)

func disconnectNode(node):
	if ConnectedNodes.has(node):
		ConnectedNodes.erase(node)
	else:
		print("invalid node disconnection")
