extends TakerNode

@export var BlankReturnForm = {
	"To":0, #Requestee
	"Power":0 #Requested Amount
}

func _ready():
	Utils.WebChanged.connect(updateDistances)
	Utils.Suppliers.append(self)
	updateDistances()

func _physics_process(delta):
	$Label.text = str(StoredPower)

func getPower():
	if StoredPower <= StoredPowerThreshold:
		requestPower()

func send(data):
	returnRequest(data)

func returnRequest(data):
	if data.From == self:
		return
	if self != data.PowerParent || data.PowerParent != null:
		return
	else:
		data.PowerParent = self
		data.ParentGateway = ConnectedNodes.duplicate(false)
	
	var ReturnForm = BlankReturnForm
	ReturnForm.To = data.From
	
	if StoredPower >= data.Power:
		StoredPower -= data.Power
		ReturnForm.Power = data.Power
	else:
		return
	
	data.From.receive(ReturnForm)

func updateDistances():
	for i in ConnectedNodes.size():
		if ConnectedNodes[i] != null && ConnectedNodes[i].has_method("setDistanceFrom"):
			ConnectedNodes[i].setDistanceFrom([self], 0)

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		connectNode(prospectiveNode)
		updateDistances()

func _on_powertimer_timeout():
	getPower()
