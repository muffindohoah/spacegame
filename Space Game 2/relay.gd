extends Node2D

var ConnectedNodes = {}
var Distances = {"power":[]}
 
@onready var DetectionArea = $Connector
@onready var DetectionAreaShape = $Connector/CollisionShape2D

var DetectionRadius = 88

#each node has to send to more then one, figure that out

# Called when the node enters the scene tree for the first time.
func _ready():
	DetectionAreaShape.shape.radius = DetectionRadius

func connectNode(node):
	
	
	var WireScene = load("res://wire.tscn").instantiate()
	WireScene.WiredFrom = self
	WireScene.WiredTo = node
	get_parent().add_child(WireScene)
	
	ConnectedNodes[ConnectedNodes.size()] = node

func disconnectNode(node):
	if ConnectedNodes.has(node):
		ConnectedNodes.erase(node)
	else:
		print("invalid node disconnection")

func setDistanceFrom(fromlog, distance):
	if fromlog.has(self) == true:
		return
	
	#show distance between you and from
	var distanceFrom = distance + 1
	$Label.text = str(distanceFrom)
	#cache the distance between you and the from 
	if fromlog[0].is_in_group("power"):
		
		Distances["power"].append(distanceFrom)
	
	var senders = fromlog
	senders.append(self)
	#send it off to request from it's connected nodes
	relaysetDistance(senders, distanceFrom)

func relaysetDistance(fromlog, distance):
	
	var prospectiveConnectors = ConnectedNodes.values()
	
	prospectiveConnectors.erase(prospectiveConnectors.find(self))
	
	
	for Connector in prospectiveConnectors.size():
		if Connector > prospectiveConnectors.size():
			
			if prospectiveConnectors[Connector].is_in_group("relay") != true:
				
				prospectiveConnectors.erase(prospectiveConnectors[Connector])
			
			if prospectiveConnectors.size() > Connector:
				
				prospectiveConnectors.erase(prospectiveConnectors[Connector])
	
	
	for Connector in range(prospectiveConnectors.size()):
		
		if prospectiveConnectors[Connector].is_in_group("relay"):
			
			prospectiveConnectors[Connector].call_deferred("setDistanceFrom",fromlog, distance)


func send(data):
	for i in ConnectedNodes.is_in_group("relay"):
		if data.To == "Power":
			for j in ConnectedNodes[i].Distances.Power.size():
				var possibleRelays = ConnectedNodes[i].Distances.Power
				possibleRelays.sort()
				relaySend(possibleRelays.front(), data)


func relaySend(to, data):
	to.send(data)


func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		
		connectNode(prospectiveNode)
