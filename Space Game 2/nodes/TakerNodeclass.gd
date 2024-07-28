class_name TakerNode

extends BasicNode

@export var StoredPowerThreshold = 5
@export var PowerFrequency = 1
@export var PoweredThreshold = 1
var Powered = 0

@export var RequestForm = {
	"From":self,
	"To":"Power",
	"Power":1,
	"PowerParent":null,
	"ParentGateway":null,
	"Couriers":[]
	}

func _ready():
	Utils.Demanders.append(self)

func getPower():
	if StoredPower > 0:
		StoredPower -= 1
	if StoredPower <= StoredPowerThreshold:
		requestPower()

func receive(data):
	
	StoredPower += data.Power

func requestPower():
	RequestForm.Couriers.clear()
	for i in ConnectedNodes.size():
		if ConnectedNodes[i] != null:
			if ConnectedNodes[i].is_in_group("relay") or ConnectedNodes[i].is_in_group("power"):
				
				ConnectedNodes[i].call_deferred("send", RequestForm)
				

func deadEnd(from):
	print(RequestForm.PowerParent, from)
	
	if RequestForm.PowerParent == from:
		
		RequestForm.PowerParent = null
		
	elif RequestForm.ParentGateway != null:
		if RequestForm.ParentGateway.has(from):
			
			RequestForm.PowerParent = null

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		connectNode(prospectiveNode)
