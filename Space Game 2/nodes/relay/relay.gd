extends BasicNode

var Distances = {"Power":[]}
 
@onready var DetectionArea = $Connector
@onready var DetectionAreaShape = $Connector/CollisionShape2D

var DetectionRadius = 88

#Each node has to send to more then one, figure that out

#Called when the node enters the scene tree for the first time.
func _ready():
	NavBus.add_node_to_nav(self)
	DetectionAreaShape.shape.radius = DetectionRadius

func send(data):
	
	for i in ConnectedNodes.size():
		if data.Map.has(self):
			var handoff_node = data.Map[data.Map.find(self) + 1]
			if ConnectedNodes.has(handoff_node) && handoff_node != data.From:
				
				ConnectedNodes[ConnectedNodes.find(handoff_node)].send(data)
				
				pulse_wire(handoff_node)

func pulse_wire(connectedto):
	for i in ConnectedWires.size():
		if ConnectedWires[i].WiredTo or ConnectedWires[i].WiredFrom == self and ConnectedWires[i].WiredTo or ConnectedWires[i].WiredFrom == connectedto:
			ConnectedWires[i].pulse()

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		if !area.get_parent().is_in_group("asteroid"):
			
			connectNode(prospectiveNode)
