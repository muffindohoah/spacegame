extends BasicNode

var Distances = {"Power":[]}
 
@onready var DetectionArea = $Connector
@onready var DetectionAreaShape = $Connector/CollisionShape2D

var DetectionRadius = 88

#Each node has to send to more then one, figure that out

#Called when the node enters the scene tree for the first time.
func _ready():
	DetectionAreaShape.shape.radius = DetectionRadius

func setDistanceFrom(fromlog, distance):
	if fromlog.has(self) == true:
		return
	
	#show distance between you and from
	var distanceFrom = distance + 1
	$Label.text = str(distanceFrom)
	#cache the distance between you and the from 
	
	
	if fromlog[0].is_in_group("power"):
		
		Distances.Power.append(distanceFrom)
	
	var senders = fromlog
	senders.append(self)
	#send it off to request from it's connected nodes
	relaysetDistance(senders, distanceFrom)

func relaysetDistance(fromlog, distance):
	
	var prospectiveConnectors = ConnectedNodes.duplicate()
	
	prospectiveConnectors.erase(prospectiveConnectors.find(self))
	
	
	for Connector in prospectiveConnectors.size():
		if Connector > prospectiveConnectors.size():
			
			if prospectiveConnectors[Connector].is_in_group("relay") != true:
				
				prospectiveConnectors.erase(prospectiveConnectors[Connector])
			
			if prospectiveConnectors.size() > Connector:
				
				prospectiveConnectors.erase(prospectiveConnectors[Connector])
	
	
	for Connector in prospectiveConnectors.size():
		if prospectiveConnectors[Connector] != null:
			if prospectiveConnectors[Connector].is_in_group("relay"):
				
				prospectiveConnectors[Connector].call_deferred("setDistanceFrom",fromlog, distance)


func send(data):
	
	if data.Couriers.has(self):
		return
	data.Couriers.append(self)
	var possibleRelays = {}
	for i in ConnectedNodes.size():
		if ConnectedNodes[i] != null:
			if ConnectedNodes[i].is_in_group("relay"):
				match data.To:
					"Power":
						
						if ConnectedNodes[i].Distances.Power.min() < self.Distances.Power.min():
							
							call_deferred("relaySend", ConnectedNodes[i], data)
		
		
		
		if ConnectedNodes[i] != null:
			if ConnectedNodes[i].is_in_group("power") && ConnectedNodes[i] != self:
				if ConnectedNodes[i].StoredPower >= data.Power:
					relaySend(ConnectedNodes[i], data)
					
				else:
					data.From.deadEnd(ConnectedNodes[i])



func relaySend(to, data):
	to.send(data)


func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		
		connectNode(prospectiveNode)
