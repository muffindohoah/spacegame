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
	#print(fromlog[0])
	
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
						
						
						print(ConnectedNodes[i].Distances.Power.min(), "you<->me", self.Distances.Power.min())
						if ConnectedNodes[i].Distances.Power.min() < self.Distances.Power.min():
							
							possibleRelays[ConnectedNodes[i].Distances.Power] = []
							possibleRelays[ConnectedNodes[i].Distances.Power].append([ConnectedNodes[i]])
		
		var closestRelay
		var sortableRelays = possibleRelays.keys()
		if sortableRelays.min():
			closestRelay = (possibleRelays[sortableRelays.min()])[0][0]
		
		
		if closestRelay != null && !data.Couriers.has(closestRelay):
			call_deferred("relaySend", closestRelay, data)
		
		
		if ConnectedNodes[i] != null:
			if ConnectedNodes[i].is_in_group("power"):
				if ConnectedNodes[i].StoredPower >= data.Power:
					relaySend(ConnectedNodes[i], data)
					print("send to mama", data.From)
					return
		elif !closestRelay:
			data.From.deadEnd(self)



func relaySend(to, data):
	print(str(to))
	to.send(data)


func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		
		connectNode(prospectiveNode)
