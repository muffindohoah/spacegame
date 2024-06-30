class_name BasicNode

extends Node2D

var ConnectedNodes = []
 
func connectNode(node):
	print(ConnectedNodes, node)
	if !ConnectedNodes.has(node):
		var WireScene = load("res://nodes/wire.tscn").instantiate()
		WireScene.WiredFrom = self
		WireScene.WiredTo = node
		get_parent().add_child.call_deferred(WireScene)
		ConnectedNodes.append(node)
		node.connectNode(self)

	else:
		print("duplicate node connection")

func disconnectNode(node):
	if ConnectedNodes.has(node):
		ConnectedNodes.erase(node)
	else:
		print("invalid node disconnection")
